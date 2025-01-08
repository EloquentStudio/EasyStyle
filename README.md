# Classic

A comprehensive utility library designed to standardize and simplify the management of styles across web application and cache styles. This library facilitates consistent styling, theme management and dynamically combine components styles i.e varient,size.

##  What's in it?

Picture this: You're a web developer tired of juggling stylesheets like a circus performer with too many flaming torches. Well, grab your virtual wand because we're about to turn that CSS circus into a well-choreographed dance party!

1. Manages all your component or html elements styles in single place.

2. One change of text and POOF! Your entire app's theme changes faster than you can say "abracadabra"

3. No more playing "Find and Replace" across 100 files when your client decides hot pink isn't their brand color anymore.

4. Mix and match variants like you're playing dress-up with your code.

5. "Small", "Large", "Primary", "Secondary" - it's like a fashion show where every component/html elements gets its moment to shine!

6. Toss in a base style, add a pinch of variant magic, sprinkle some size adjustments and Your components/html elements are dressed to impress.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add classic
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install classic
```

## Usage

1. Configuration.
  - `files` is location of your styles yml.
  - `raise_error_on_not_found`. Default value is `false`.
    If style not found then raise an error. Disable on production environment.
    i.e `config.raise_error_on_not_found = Rails.env.development?`
  - `auto_reload_on_change` Rails only flag will reload styles on yaml files changes.
    Default value is `false`. Enable in rails development env.
    i.e `config.auto_reload_on_change = !Rails.env.development?`
  - `classes_merge_handler` handle custom merging of classes.
    Default is `proc { |classes| classes.join(" ") }`
    i.e
    ```ruby
      tw_class_merge = TailwindMerge::Merger.new
      proc { |classes| class_merge.merge(classes) }
    ```

  ```ruby

  tw_class_merge = TailwindMerge::Merger.new

  Classic.configure do |config|
    config.files = Dir["style/**/*.yaml"]
    config.raise_error_on_not_found = true
    config.auto_reload_on_change = true # For rails only.
    config.classes_merge_handler = proc { |classes| tw_class_merge.merge(classes) }
  end
  ```

2. How to define style using yml.

  ```yml
  btn:
    base: inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-5
    varient:
      default: bg-primary text-primary-foreground shadow hover:bg-primary/90
      destructive: bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90
      outline: border border-input bg-transparent shadow-sm hover:bg-accent hover:text-accent-foreground
      secondary: bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80
      ghost: hover:bg-accent hover:text-accent-foreground
      link: text-primary underline-offset-4 hover:underline
    size:
      default: h-9 px-4 py-2
      sm: h-8 rounded-md px-3 text-xs
      lg: h-10 rounded-md px-8
      icon: h-9 w-9
    default: "(varient.default,size.default)"

  card:
    <self: rounded-xl border bg-card text-card-foreground shadow
    header: flex flex-col space-y-1.5 p-6
    title: font-semibold leading-none tracking-tight
    description: text-sm text-muted-foreground
    content: p-6 pt-0
    footer: flex items-center p-6 pt-0

  "@aliases":
    btn-primary: "btn(varient.outline,size.default)"
  ```

3. How to use in erb, haml templates or any other templates by calling "to_cls" method on string.

  * Combine options.
    - `btn(varient.outline,size.lg).to_cls`
    - `btn(varient.link,size.default).to_cls`

  * Default style define in  `default` key.
    - `btn.to_cls`

  * How to use alias?
    - `btn-primary.to_cls`

  * `<self` - Element has multiple sub component/element style key and want to use parent key as a container.
    - `card.to_cls` This will use `<self` key of card.

  * Add custom classes.
    - `btn(varient.outline,size.lg).to_cls("mt-2 px-2")`
    - `btn.to_cls("mt-2 px-2")` # it will merge classes to btn default syle

  * If you are using Tailwind css then add yaml files to your tailwind config content section.
    i.e
    ```
    content: [
      "./styles/*.yaml"
    ],
    ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/EloquentStudio/classic. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/EloquentStudio/classic/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Classic project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/EloquentStudio/classic/blob/master/CODE_OF_CONDUCT.md).
