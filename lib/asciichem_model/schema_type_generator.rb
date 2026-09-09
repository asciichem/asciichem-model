# frozen_string_literal: true

require "pathname"
require "yaml"

module AsciiChemModel
  # Emits TypeScript interfaces from the v1 JSON Schemas — single
  # source of truth (schemas) → typed output for downstream TS
  # consumers. Glossarist's concept-model generator is the
  # architectural reference.
  #
  # Supports the schema features this repository uses: type, const,
  # enum, required, properties, items, anyOf, $ref (sibling files),
  # and object-valued properties (emitted as inline structural
  # types). `check_mode` compares against committed output so CI
  # fails on drift.
  class SchemaTypeGenerator
    SCHEMAS_DIR = Pathname.new(File.join(AsciiChemModel.root, "schemas", "v1"))
    OUTPUT_DIR = SCHEMAS_DIR.join("types")

    # Schema basenames whose model class spelling differs from the
    # mechanical kebab→Camel conversion.
    NAME_EXCEPTIONS = { "zmatrix" => "ZMatrix" }.freeze

    class << self
      def type_name(schema_basename)
        NAME_EXCEPTIONS.fetch(schema_basename) do
          schema_basename.split("-").map(&:capitalize).join
        end
      end
    end

    def initialize(check_mode: false)
      @check_mode = check_mode
    end

    def run
      OUTPUT_DIR.mkpath
      schema_files.each { |path| emit_one(path) }
      emit_index
      @check_mode ? fail_if_drift : 0
    end

    private

    def schema_files
      Dir[SCHEMAS_DIR.join("*.yaml").to_s].sort
    end

    def emit_one(path)
      basename = File.basename(path, ".yaml")
      schema = YAML.safe_load_file(path)
      write_output("#{basename}.ts", render_header(basename) + render_schema(schema))
    end

    def emit_index
      names = schema_files.map { |p| self.class.type_name(File.basename(p, ".yaml")) }
      body = +render_comment("Union of every node type in the v1 model.")
      body << "export type Node =\n"
      body << names.map { |n| "  | #{n}" }.join("\n")
      body << ";\n"
      write_output("index.ts", body)
    end

    def render_header(basename)
      render_comment("Generated from schemas/v1/#{basename}.yaml — do not edit; regenerate.")
    end

    def render_schema(schema)
      name = self.class.type_name(schema["$id"].split("/").last)
      out = +"export interface #{name} {\n"
      required = schema.fetch("required", [])
      props = schema.fetch("properties", {})
      out << render_property("type", props.fetch("type"), true, name) if props.key?("type")
      props.reject { |key, _| key == "type" }.each do |key, prop|
        out << render_property(ts_key(key), prop, required.include?(key), name)
      end
      out << "}\n"
    end

    def render_property(key, prop, required, scope)
      optional = required ? "" : "?"
      "#{indent}readonly #{key}#{optional}: #{ts_type(prop, scope)};\n"
    end

    def ts_type(prop, scope)
      return ts_const(prop["const"]) if prop["const"]
      return ts_enum(prop["enum"]) if prop["enum"]
      return ts_ref(prop["$ref"], scope) if prop["$ref"]
      return ts_array(prop, scope) if prop["type"] == "array"
      return ts_inline_object(prop, scope) if prop["type"] == "object"

      case prop["type"]
      when "number" then "number"
      when "integer" then "number"
      else "string"
      end
    end

    def ts_const(value)
      value.is_a?(String) ? %("#{value}") : value.to_s
    end

    def ts_enum(values)
      values.map { |v| ts_const(v) }.join(" | ")
    end

    def ts_ref(ref, _scope)
      self.class.type_name(File.basename(ref.to_s, ".yaml"))
    end

    def ts_array(prop, scope)
      items = prop["items"]
      inner = if items.key?("anyOf")
                "(#{items["anyOf"].map { |sub| ts_type(sub, scope) }.uniq.join(" | ")})"
              else
                ts_type(items, scope)
              end
      "#{inner}[]"
    end

    def ts_inline_object(prop, scope)
      required = prop.fetch("required", [])
      members = prop.fetch("properties", {}).map do |key, sub|
        optional = required.include?(key) ? "" : "?"
        "#{indent}#{ts_key(key)}#{optional}: #{ts_type(sub, scope)};"
      end
      "{\n#{members.map { |m| "  #{m}" }.join("\n")}\n#{indent}}"
    end

    def ts_key(key)
      return %("#{key}") unless key.match?(/\A[A-Za-z_$][A-Za-z0-9_$]*\z/)

      key
    end

    def indent
      "  "
    end

    def render_comment(text)
      "// #{text}\n"
    end

    def write_output(filename, content)
      path = OUTPUT_DIR.join(filename)
      @written ||= {}
      @written[filename] = content
      File.write(path, content) unless @check_mode
    end

    def fail_if_drift
      drifted = @written.select do |filename, content|
        path = OUTPUT_DIR.join(filename)
        !File.exist?(path) || File.read(path) != content
      end
      return 0 if drifted.empty?

      warn "Generated types drifted from schemas/v1/types (run `rake generate:types`): #{drifted.keys.join(', ')}"
      1
    end
  end
end
