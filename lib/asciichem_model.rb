# frozen_string_literal: true

# AsciiChemModel packages the normative semantic model artifacts
# (LutaML definitions, JSON Schemas, examples) for the AsciiChem
# ecosystem. The gem's lib currently carries only the version and
# schema tooling entry points; the schema self-check suite and the
# schema→TypeScript type generator land with the backlog items
# tracked in the ecosystem TODO.impl (32).
module AsciiChemModel
  autoload :VERSION, "asciichem_model/version"

  # Root path of the gem (schemas/, models/, examples/ live here).
  def self.root
    File.expand_path("..", __dir__)
  end
end
