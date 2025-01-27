# frozen_string_literal: true

require_relative "classic/version"
require_relative "classic/string_ext"
require_relative "classic/configuration"
require_relative "classic/manager"
require_relative "classic/railtie" if Object.const_defined?("Rails::Railtie")

module Classic
  class Error < StandardError; end

  class NotFoundError < StandardError; end

  def self.configure
    config = Configuration.new
    yield config
    config.classes_merge_handler ||= proc { |classes| classes.join(" ") }
    config.validate

    @classic = Classic::Manager.new(config: config)
    @classic.load

    if config.auto_reload_on_change && Object.const_defined?("Rails::Railtie")
      Classic::Railtie.initializers.each(&:run)
    end
  end

  def self.reload!
    @classic.load
  end

  def self.object
    @classic
  end

  def self.cls(name, classes = nil)
    @classic.cls(name, classes)
  end
end
