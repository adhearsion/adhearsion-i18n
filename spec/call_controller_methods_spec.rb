# encoding: utf-8

require 'spec_helper'

describe CallControllerMethods do
  describe 'getting and setting the locale'

  describe 'requesting a translation' do
    it 'should use a default locale'

    it 'should allow overriding the locale per-request'

    it 'should allow overriding the locale for the entire call'

    it 'should generate proper SSML with both audio and text translations'

    it 'should generate proper SSML with only audio (no text) translations'

    it 'should generate proper SSML with only text (no audio) translations'

    it 'should generate a path to the audio prompt based on the requested locale'

  end

end
