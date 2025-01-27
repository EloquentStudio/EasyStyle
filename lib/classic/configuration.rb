# frozen_string_literal: true

module Classic
  class Configuration
    attr_accessor :files, :file_prefix, :raise_error_on_not_found, :classes_merge_handler,
      :auto_reload_on_change

    def validate
      if files.nil? || files.empty?
        puts "[Classic configuration] style directory not present or 'files' in style directory not present."
      end
    end
  end
end
