# frozen_string_literal: true

require "json_schemer"
require "yaml"

module AsciiChemModel
  # Schema self-checks for the model repository: every schema is
  # loadable and structurally coherent, positive examples validate
  # against their node's schema, and negative examples (99-*) are
  # rejected. The same machinery serves downstream consumers that
  # want to validate canonical-JSON payloads against the shipped
  # schemas.
  module Validators
    SCHEMAS_DIR = File.join(AsciiChemModel.root, "schemas", "v1")
    NEGATIVE_MARKER = "99-".freeze
    private_constant :NEGATIVE_MARKER

    class << self
      # A hash of schema name (file basename) => JSONSchemer schema,
      # with sibling-file $refs resolvable.
      def schemers
        @schemers ||= schema_files.to_h do |path|
          [File.basename(path, ".yaml"), schemer_for(path)]
        end
      end

      # Sibling schemas are loaded exactly once and the SAME object is
      # returned for every $ref resolution. json_schemer retains one
      # compiled subschema per resolved object; returning a fresh
      # YAML.load per lookup made retention grow with every
      # validation x ref hit (gigabytes on corpus-scale runs).
      def loaded_schema(basename)
        @loaded_schemas ||= {}
        @loaded_schemas[basename] ||= YAML.safe_load_file(schema_file(basename))
      end

      def schema_names
        schemers.keys.sort
      end

      def schema_file(name)
        base = name.end_with?(".yaml") ? name : "#{name}.yaml"
        File.join(SCHEMAS_DIR, base)
      end

      # Validates a wire-form node hash against its node schema
      # (chosen by the `type` discriminator). Returns an Array of
      # error strings (empty when valid); raises KeyError for an
      # unknown schema name.
      def validate(node)
        schema_name = node.fetch("type").tr("_", "-")
        schemer = schemers.fetch(schema_name) do
          raise KeyError, "no schema for node type #{schema_name.inspect}"
        end
        schemer.validate(node).map(&:to_s)
      end

      def example_files
        Dir[File.join(SCHEMAS_DIR, "examples", "*.yaml")].sort
      end

      def positive_examples
        example_files.reject { |p| File.basename(p).start_with?(NEGATIVE_MARKER) }
      end

      def negative_examples
        example_files.select { |p| File.basename(p).start_with?(NEGATIVE_MARKER) }
      end

      private

      def schema_files
        Dir[File.join(SCHEMAS_DIR, "*.yaml")].sort
      end

      def schemer_for(path)
        JSONSchemer.schema(YAML.safe_load_file(path), ref_resolver: method(:resolve_ref))
      end

      # Sibling-file $refs ("atom.yaml") resolve against the schemas
      # directory; external pointers are not supported by design.
      def resolve_ref(uri)
        basename = File.basename(uri.to_s)
        return loaded_schema(basename) if File.exist?(schema_file(basename))

        raise KeyError, "unresolvable $ref #{uri} (only sibling schema files are supported)"
      end
    end
  end
end
