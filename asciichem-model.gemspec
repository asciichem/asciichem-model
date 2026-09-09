# frozen_string_literal: true

require_relative "lib/asciichem_model/version"

Gem::Specification.new do |spec|
  spec.name = "asciichem-model"
  spec.version = AsciiChemModel::VERSION
  spec.authors = ["AsciiChem contributors"]
  spec.summary = "Normative semantic model and schemas for the AsciiChem ecosystem"
  spec.description = "LutaML model definitions and versioned JSON Schemas that every " \
                     "AsciiChem implementation (Ruby, TypeScript, Python) conforms to."
  spec.homepage = "https://asciichem.github.io"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.files = Dir["README.adoc", "LICENSE", "lib/**/*.rb",
                   "models/**/*.lutaml", "schemas/**/*.yaml",
                   "docs/**/*.adoc"].freeze
  spec.require_paths = ["lib"]
end
