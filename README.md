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

adhearsion-i18n uses the [i18n gem](https://github.com/svenfuchs/i18n).  For example, if you want to change the default locale, put something like this in config/adhearsion.rb:

```Ruby
I18n.default_locale = :de
```

More docs (though admittedly Rails-specific - read carefully) can be found at http://guides.rubyonrails.org/i18n.html

## Examples

en.yml:

```yaml
en:
  string1:
    audio: /path/to/string1.wav
    text: 'String One'

  string2:
    audio: '/path/to/string2.wav'

  string3:
    text: 'String Three'
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

Translations can also be used outside call controllers via `AdhearsionI18n.t`:

en.yml:

```yaml
en:
  order_recommendations:
    new_customer:
      text: Thank you for calling! Try today's special made just for you.
      audio: recommendations/new_customer
    returning_customer:
      text: Welcome back! You haven't tried today's special made just for you!
      audio: recommendations/returning_customer
    loyal_customer:
      text: You are special!
      audio: recommendations/loyal_customer
```

orders_controller.rb:

```Ruby
class OrdersController < Adhearsion::CallController
  def run
    order = Order.new(user)
    play order.recommendation
  end
end
```

order.rb:

```Ruby
class Order
  def initialize(user)
    @user = user
  end

  def recommendation
    if @user.total_calls == 1
      AdhearsionI18n.t('recommendations/new_customer')
    elsif (@user.total_calls > 10) || (@user.total_purchases > 500)
      AdhearsionI18n.t('recommendations/loyal_customer')
    else
      AdhearsionI18n.t('recommendations/returning_customer')
    end
  end
end
```

## String interpolations

adhearsion-i18n supports string interpolations just as i18n itself does. However there are some guidelines we recommend:

* When you want to craft TTS strings that contain variable data, use SSML instead
* Use interpolations only for audio files, not for TTS text strings

The reason for this is that it is not practical to assume that you can interpolate text into a recorded audio file. Thus while your app may start with TTS-only today, following this practice will ensure that you can more easily convert to recorded audio in the future.

Example:

Bad:

```Ruby
play t(:hello, name: 'Ben')
```

Good:

```Ruby
play t(:hello), 'Ben'
```

Further discussion on this issue can be found in [issue #3](https://github.com/adhearsion/adhearsion-i18n/issues/3).

## Verifying audio prompts

adhearsion-i18n adds a rake task to Adhearsion applications that will check to ensure each defined audio file is present in the application.  This assumes that the audio files are kept in the Adhearsion application itself and not hosted externally.

Given a YAML locale file like:

```yaml
en:
  hello:
    audio: hello.wav
  missing_prompt:
    audio: missing_prompt.wav
```

Assuming the default location of `#{Adhearsion.root}/audio`, this example assumes that `hello.wav` is present, but `missing_prompt.wav` is missing.

Then run the rake task to validate the prompts and see output like this:

```Bash
$ rake i18n:validate_files
[2014-05-07 16:03:00.792] DEBUG AdhearsionI18n::Plugin: Adding /Users/bklang/myapp/config/locales to the I18n load path
[2014-05-07 16:03:00.792] INFO  AdhearsionI18n::Plugin: Adhearsion I18n loaded

Adhearsion configured environment: development
[2014-05-07 16:03:00.833] INFO  Object: [en] Missing audio file: /Users/bklang/myapp/audio/en/missing_prompt.wav
[2014-05-07 16:03:00.833] ERROR Object: Errors detected! Number of errors by locale:
[2014-05-07 16:03:00.833] ERROR Object: [en]: 1 missing prompts
```

## Credits

Copyright (C) 2014 The Adhearsion Foundation

adhearsion-i18n is released under the [MIT license](http://opensource.org/licenses/MIT). Please see the [LICENSE](https://github.com/adhearsion/adhearsion-i18n/blob/master/LICENSE) file for details.

adhearsion-i18n was created by [Ben Klang](https://twitter.com/bklang) with support from [Mojo Lingo](https://mojolingo.com) and their clients.
