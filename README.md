adhearsion-i18n
===============

Internationalization for Adhearsion apps

## Installing

Simply add to your Gemfile like any other Adhearsion plugin:

```Ruby
gem 'adhearsion-i18n'
```

## Configuration

See `rake config:show` to see a full list of options.

Make sure to create your locales in `config/locales` within your Adhearsion app.

## Examples

en.yml:

```yaml
en:
  string1:
    audio: /path/to/string1.wav
    text: String One

  string2:
    audio: /path/to/string2.wav

  string3:
    text: String Three
```

example_controller.rb:

```Ruby
class ExampleController < Adhearsion::CallController
  def run
    answer

    play t(:string1)
    # SSML generated: <speak><audio src="/path/to/string1.wav">String One</audio></speak>

    play t(:string2)
    # SSML generated: <speak><audio src="/path/to/string2.wav"></audio></speak>

    play t(:string3)
    # SSML generated: <speak>String Three</speak>
  end
end
```

