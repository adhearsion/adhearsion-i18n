# encoding: utf-8

%w{
  version
  plugin
  formatter
  call_controller_methods
}.each { |r| require "adhearsion-i18n/#{r}" }

class AdhearsionI18n

  def self.t(key, options = {})
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

    if prompt.empty?
      output_formatter.ssml_for_text(text, language: this_locale)
    else
      RubySpeech::SSML.draw language: this_locale do
        if Adhearsion.config.i18n.fallback
          audio(src: prompt) { string text }
        else
          audio(src: prompt)
        end
      end
    end
  end

  def self.locale
    I18n.locale || I18n.default_locale
  end

  def self.output_formatter
    AdhearsionI18n::Formatter.new
  end
end
