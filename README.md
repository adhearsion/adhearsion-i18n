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

## Credits

Copyright (C) 2014 The Adhearsion Foundation

adhearsion-i18n is released under the [MIT license](http://opensource.org/licenses/MIT). Please see the [LICENSE](https://github.com/bklang/sippy_cup/blob/master/LICENSE) file for details.

adhearsion-i18n was created by [Ben Klang](https://twitter.com/bklang) with support from [Mojo Lingo](https://mojolingo.com) and their clients.
