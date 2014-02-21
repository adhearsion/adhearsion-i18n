# encoding: utf-8

module AdhearsionI18n::CallControllerMethods
  def t(key)
    prompt = ::I18n.t "#{key.to_s}.audio", default: ''
    text   = ::I18n.t "#{key.to_s}.text"

    RubySpeech::SSML.draw do
      if prompt.empty?
        string text
      else
        audio(src: prompt) { string text }
      end
    end
  end
end
