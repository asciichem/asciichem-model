# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Regenerate TypeScript types from the v1 schemas"
task :"generate:types" do
  require "asciichem_model"
  exit AsciiChemModel::SchemaTypeGenerator.new.run
end

desc "Fail if generated TypeScript types drifted from the schemas"
task :"generate:types:check" do
  require "asciichem_model"
  exit AsciiChemModel::SchemaTypeGenerator.new(check_mode: true).run
end

task default: :spec
