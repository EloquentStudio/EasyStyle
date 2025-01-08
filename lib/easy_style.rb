# frozen_string_literal: true

require_relative "easy_style/version"
require_relative "easy_style/string_ext"
require_relative "easy_style/configuration"
require_relative "easy_style/manager"
require_relative "easy_style/railtie" if Object.const_defined?("Rails::Railtie")

module EasyStyle
  class Error < StandardError; end

  class NotFoundError < StandardError; end

  def self.configure
    config = Configuration.new
    yield config
    config.classes_merge_handler ||= proc { |classes| classes.join(" ") }
    config.validate!

    @easy_style = EasyStyle::Manager.new(config: config)
    @easy_style.load

    if config.auto_reload_on_change && Object.const_defined?("Rails::Railtie")
      EasyStyle::Railtie.initializers.each(&:run)
    end
  end

  def self.reload!
    @easy_style.load
  end

  def self.object
    @easy_style
  end

  def self.cls(name, classes = nil)
    @easy_style.cls(name, classes)
  end
end
