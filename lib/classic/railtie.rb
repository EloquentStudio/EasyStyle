# frozen_string_literal: true

module Classic
  # Auto loader on style files change.
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      Classic::Railtie.watch_style_files(app)
    end

    def self.watch_style_files(app)
      return unless Classic.object

      style_files = Classic.object.files.map { |f| Rails.root.join(f).to_s }
      reloader = app.config.file_watcher.new(style_files) {}
      app.reloaders << reloader
      app.reloader.to_run do
        reloader.execute_if_updated { Classic.reload! }
      end
    end
  end
end
