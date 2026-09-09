# frozen_string_literal: true

require "spec_helper"
require "yaml"

RSpec.describe AsciiChemModel::Validators do
  it "loads every shipped schema" do
    expect(described_class.schema_names).to include(
      "atom", "molecule", "identifier", "formula", "group", "bond",
      "reaction", "reaction-cascade", "electron-configuration",
      "embedded-math", "text", "name", "mechanism", "spectrum",
      "crystal", "zmatrix", "calculation", "provenance", "substance-record"
    )
  end

  it "validates every positive example against its node schema" do
    described_class.positive_examples.each do |path|
      example = YAML.safe_load_file(path)
      errors = described_class.validate(example)
      expect(errors).to be_empty, "#{path}: #{errors.join('; ')}"
    end
  end

  it "rejects every negative example (99-*)" do
    expect(described_class.negative_examples.length).to be >= 3
    described_class.negative_examples.each do |path|
      example = YAML.safe_load_file(path)
      expect(described_class.validate(example)).not_to be_empty, path
    end
  end

  it "raises for an unknown node type" do
    expect { described_class.validate({ "type" => "warp-field" }) }
      .to raise_error(KeyError, /warp-field/)
  end

  it "resolves sibling-file refs (molecule example nests atoms)" do
    example = YAML.safe_load_file(
      File.join(AsciiChemModel.root, "schemas", "v1", "examples", "02-molecule-water.yaml")
    )
    expect(described_class.validate(example)).to be_empty
  end
end
