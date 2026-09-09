# frozen_string_literal: true

require "spec_helper"

RSpec.describe AsciiChemModel::SchemaTypeGenerator do
  let(:output_dir) { Pathname.new(File.join(AsciiChemModel.root, "schemas", "v1", "types")) }

  it "generates an interface per schema plus a Node union index" do
    described_class.new.run
    atom = File.read(output_dir.join("atom.ts"))
    expect(atom).to include("export interface Atom")
    expect(atom).to include('readonly type: "atom";')
    expect(atom).to include("readonly element: string;")
    expect(atom).to include("readonly isotope?: string;")

    index = File.read(output_dir.join("index.ts"))
    expect(index).to include("export type Node =")
    expect(index).to include("| Atom")
    expect(index).to include("| SubstanceRecord")
  end

  it "maps enums to unions and refs to named types" do
    described_class.new.run
    identifier = File.read(output_dir.join("identifier.ts"))
    expect(identifier).to include('"cas" | "inchi" | "inchikey" | "smiles"')

    molecule = File.read(output_dir.join("molecule.ts"))
    expect(molecule).to include("Atom[]")
    expect(molecule).to include("Identifier[]")
  end

  it "check mode passes when output is fresh" do
    described_class.new.run
    expect(described_class.new(check_mode: true).run).to eq(0)
  end

  it "check mode fails when the committed output drifted" do
    described_class.new.run
    drifted = output_dir.join("atom.ts")
    original = File.read(drifted)
    File.write(drifted, original.sub("element", "elements"))
    expect(described_class.new(check_mode: true).run).to eq(1)
    File.write(drifted, original)
  end

  it "names the zmatrix type after its model class" do
    expect(described_class.type_name("zmatrix")).to eq("ZMatrix")
    expect(described_class.type_name("reaction-cascade")).to eq("ReactionCascade")
  end
end
