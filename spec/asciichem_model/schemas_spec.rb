# frozen_string_literal: true

require "spec_helper"
require "yaml"

RSpec.describe "asciichem-model schemas" do
  SCHEMAS_DIR = File.join(AsciiChemModel.root, "schemas", "v1")
  EXAMPLES_DIR = File.join(SCHEMAS_DIR, "examples")

  def schema_files
    Dir[File.join(SCHEMAS_DIR, "*.yaml")].sort
  end

  def example_files
    Dir[File.join(EXAMPLES_DIR, "*.yaml")].sort
  end

  it "ships at least the seed node schemas" do
    names = schema_files.map { |p| File.basename(p, ".yaml") }
    expect(names).to include("atom", "molecule", "identifier")
  end

  it "every schema pins an $id, title, and object type" do
    schema_files.each do |path|
      schema = YAML.safe_load_file(path)
      expect(schema).to be_a(Hash), path
      expect(schema["$id"]).to match(%r{asciichem-model/v1/[\w-]+\z}), path
      expect(schema["title"]).to be_a(String), path
      expect(schema["type"]).to eq("object"), path
    end
  end

  it "every node schema declares a type discriminator const" do
    schema_files.each do |path|
      schema = YAML.safe_load_file(path)
      type_prop = schema.dig("properties", "type")
      expect(type_prop).to be_a(Hash), path
      expect(type_prop["const"]).to eq(File.basename(path, ".yaml")), path
    end
  end

  it "every example is a mapping whose type matches a shipped schema" do
    shipped = schema_files.map { |p| File.basename(p, ".yaml") }
    example_files.each do |path|
      example = YAML.safe_load_file(path)
      expect(example).to be_a(Hash), path
      expect(shipped).to include(example["type"]), path
    end
  end

  it "identifier schema pins the convention registry" do
    schema = YAML.safe_load_file(File.join(SCHEMAS_DIR, "identifier.yaml"))
    conventions = schema.dig("properties", "convention", "enum")
    expect(conventions).to include("cas", "inchi", "inchikey", "smiles",
                                   "canonical-smiles", "iupac-name",
                                   "pubchem-cid", "chebi")
  end

  it "lutaml definitions exist for every shipped schema" do
    schema_files.each do |path|
      name = File.basename(path, ".yaml")
      camel = name.split("-").map(&:capitalize).join
      lutaml = File.join(AsciiChemModel.root, "models", "asciichem", "#{camel}.lutaml")
      expect(File.exist?(lutaml)).to be(true), "missing #{lutaml}"
    end
  end
end
