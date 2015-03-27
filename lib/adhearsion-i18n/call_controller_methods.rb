# encoding: utf-8

module AdhearsionI18n::CallControllerMethods
  def t(key, options = {})
    this_locale = options[:locale] || locale
    options = {default: '', locale: locale}.merge(options)
    prompt = ::I18n.t "#{key}.audio", options
    text   = ::I18n.t "#{key}.text", options

    if prompt.empty? && text.empty?
      # Look for a translation key that doesn't follow the Adhearsion-I18n structure
      text = ::I18n.t key, options
    end

    unless prompt.empty?
      prompt = "#{Adhearsion.config.i18n.audio_path}/#{this_locale}/#{prompt}"
    end

    RubySpeech::SSML.draw language: this_locale do
      if prompt.empty?
        string text
      else
        if Adhearsion.config.i18n.fallback
          audio(src: prompt) { string text }
        else
          audio(src: prompt)
        end
      end
    end
  end

  def locale
    call[:locale] || I18n.default_locale
  end

  def locale=(l)
    call[:locale] = l
  end
end
