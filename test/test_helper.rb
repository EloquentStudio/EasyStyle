# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "classic"

require "minitest/autorun"
require "minitest/focus"
require "minitest/rg"

class ClassicTest < Minitest::Spec
  register_spec_type(self) do |desc, *addl|
    addl.include? :classic
  end

  def setup
    return if Classic.object

    Classic.configure do |config|
      config.files = Dir["test/fixtures/style/**/*.yml"]
      config.raise_error_on_not_found = true
    end
  end
end
