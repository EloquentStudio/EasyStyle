# frozen_string_literal: true

module Classic
  class Configuration
    attr_accessor :files, :file_prefix, :raise_error_on_not_found, :classes_merge_handler,
      :auto_reload_on_change

    def validate!
      if files.nil? || files.empty?
        raise Classic::Error, "'files' option value is required."
      end
    end
  end
end
