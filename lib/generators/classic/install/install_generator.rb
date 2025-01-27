# frozen_string_literal: true

require "rails/generators"

module Classic
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      argument :dir, type: :string, default: "style", banner: "style directory"

      desc "This generator creates an initializer file at config/initializers and style dir with default file."
      def create_classic_config_and_style_dir
        @dir_name = dir
        template "classic.rb", "config/initializers/classic.rb"
        copy_file "app.yaml", "#{@dir_name}/app.yaml"
      end
    end
  end
end
