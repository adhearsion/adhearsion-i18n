# encoding: utf-8

module AdhearsionI18n::CallControllerMethods
  def t(key, options = {})
    prompt = ::I18n.t "#{key}.audio", {default: '', locale: locale}.merge(options)
    text   = ::I18n.t "#{key}.text", {default: '', locale: locale}.merge(options)

    unless prompt.empty?
      prompt = "#{config['audio_path']}/#{locale}/#{prompt}"
    end

    RubySpeech::SSML.draw do
      if prompt.empty?
        string text
      else
        audio(src: prompt) { string text }
      end
    end
  end

  def locale
    call[:locale] || I18n.default_locale
  end

  def locale=(l)
    call[:locale] = l
  end

private

  def config
    Adhearsion.config.i18n
  end
end
