# frozen_string_literal: true

require "json"
require "yaml"

module Classic
  # Store and Proces styles.
  class Manager
    BASE_STYLE_KEY = "base"
    DEFAULT_STYLE_KEY = "default"
    SELF_STYLE_KEY = "<self"
    ALIASES_KEY = "@aliases"

    attr_reader :config, :data, :entries, :merged_css_entries

    def initialize(config:)
      @config = config
      @classes_merge_handler = config.classes_merge_handler
    end

    def files
      config.files
    end

    def load
      @data = {}
      @entries = {}
      @merged_css_entries = Hash.new({})

      files.each do |file|
        extname = File.extname(file)
        file_data = (extname == "json") ? JSON.load_file(file) : YAML.load_file(file)

        next unless file_data.is_a?(Hash)

        aliases = file_data.delete(ALIASES_KEY) if file_data.key?(ALIASES_KEY)

        if config.file_prefix
          prefix = File.basename(file).gsub(extname, "")
          @data[prefix] = file_data
          build_aliases(aliases, prefix: prefix)
        else
          @data.merge!(file_data) do |key, old_value, new_value|
            raise Classic::Error, "dublicate value found for #{key} - values #{old_value}, #{new_value}"
          end

          build_aliases(aliases)
        end
      end
    end

    def cls(name, classes = nil)
      return (@entries[name] ||= lookup(name)) unless classes

      @merged_css_entries[name][classes] ||= @classes_merge_handler.call([lookup(name), classes])
    end

    def lookup(name)
      component = @data[name] || name

      component_path = if component.is_a?(String)
        name
      elsif component.is_a?(Hash)
        # default value is style expression(i.e varient.default,size.default)) then add componet name
        # (i.e btn(varient.default,size.default)))
        # else add default to component name(i.e btn) with "." i.e(btn.default)
        if component.key?(DEFAULT_STYLE_KEY)
          if component[DEFAULT_STYLE_KEY].match?(STYLE_EXP_REGX)
            "#{name}#{component[DEFAULT_STYLE_KEY]}"
          else
            "#{name}.#{DEFAULT_STYLE_KEY}"
          end
        elsif component.key?(SELF_STYLE_KEY)
          "#{name}.#{SELF_STYLE_KEY}"
        end
      end

      if component_path
        style_fn = parse(component_path)
        classes = collect_styles(style_fn)

        return style_not_found_value(name) if classes.nil? || classes.empty?

        classes = classes.join(" ") if classes.is_a?(Array)
        classes.strip.tr("\n", " ")
      else
        style_not_found_value(name)
      end
    end

    # Matches:
    #  btn(varient.default,size.default)
    #  (varient.default,size.default)
    STYLE_EXP_REGX = /([\w.]*)\(([\w.,\s]*)\)/

    def parse(style)
      matches = style.scan(STYLE_EXP_REGX)

      if matches.any?
        component, options = matches.first

        if component.empty?
          component = options
          options = ""
        end
      else
        component = style
        options = ""
      end

      { component: component, options: options.split(",").map(&:strip), name: style }
    end

    def collect_styles(style_fn)
      component = nil

      style_fn[:component].split(".").each do |c|
        c = c.strip
        component = component ? component[c] : @data[c]
      end

      # If component is direct css class. i.e "flex flex-col space-y-1.5 p-6"
      return style_not_found_value(style_fn[:name]) unless component

      # In case of i.e "card.header" component is end result css classes.
      return component if component.is_a?(String)

      if style_fn[:options].empty?
        # Handle "label" -> will lookup "label.<self"
        return component[SELF_STYLE_KEY] if component.key?(SELF_STYLE_KEY)

        # Handle "btn.size" -> will lookup "btn.size.default"
        return component[DEFAULT_STYLE_KEY] if component.key?(DEFAULT_STYLE_KEY)
      end

      styles = []
      # If component is a Hash and has 'base' entry and has style options
      # i.e
      # btn:
      #   base: rounded-md text-sm font-medium...
      styles << component[BASE_STYLE_KEY] if component.key?(BASE_STYLE_KEY)

      style_fn[:options].each do |o|
        option = nil

        o.split(".").each do |c|
          c = c.strip
          option = option ? option[c] : component[c]
        end

        if option
          styles << option
        else
          style_not_found_value(style_fn[:name])
        end
      end

      styles
    end

    def style_not_found_value(name)
      raise NotFoundError, "'#{name}' style not found." if config.raise_error_on_not_found

      "#{name}-StyleNotFound"
    end

    def build_aliases(aliases, prefix: nil)
      aliases&.each do |name, style|
        if prefix
          @entries["#{prefix}.#{name}"] = lookup("#{prefix}.#{style}")
        else
          @entries[name] = lookup(style)
        end
      end
    end
  end
end
