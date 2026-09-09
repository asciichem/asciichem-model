# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "asciichem_model"

RSpec.configure do |config|
  config.order = :random
end
