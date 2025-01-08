# frozen_string_literal: true

module EasyStyle
  # Auto loader on style files change.
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      EasyStyle::Railtie.watch_style_files(app)
    end

    def self.watch_style_files(app)
      style_files = EasyStyle.object.files.map { |f| Rails.root.join(f).to_s }
      reloader = app.config.file_watcher.new(style_files) {}
      app.reloaders << reloader
      app.reloader.to_run do
        reloader.execute_if_updated { EasyStyle.reload! }
      end
    end
  end
end
