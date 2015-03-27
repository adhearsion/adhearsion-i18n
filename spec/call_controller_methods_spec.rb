# encoding: utf-8

require 'spec_helper'

describe AdhearsionI18n::CallControllerMethods do

  let(:call_id)     { SecureRandom.uuid }
  let(:call)        { Adhearsion::Call.new }
  let(:block)       { nil }

  subject(:controller) { Class.new(Adhearsion::CallController).new call }

  before :all do
    Adhearsion.config.i18n['locale_path'] = ["#{File.dirname(__FILE__)}/fixtures/locale"]
    Adhearsion::Plugin.init_plugins
  end

  before do
    I18n.default_locale = :en
    double call, write_command: true, id: call_id
  end

  describe 'getting and setting the locale' do
    it 'should be able to set and get the locale' do
      controller.locale.should == :en
      controller.locale = :it
      controller.locale.should == :it
    end
  end

  describe 'requesting a translation' do
    it 'should use a default locale' do
      ssml = controller.t :have_many_cats
      ssml['xml:lang'].should =~ /^en/
    end

    it 'should allow overriding the locale per-request' do
      ssml = controller.t :have_many_cats, locale: 'it'
      ssml['xml:lang'].should =~ /^it/
    end

    it 'should allow overriding the locale for the entire call' do
      controller.locale = 'it'
      ssml = controller.t :have_many_cats
      ssml['xml:lang'].should =~ /^it/
      controller2 = Class.new(Adhearsion::CallController).new call
      controller2.locale.should == 'it'
    end

    it 'should generate proper SSML with both audio and text fallback translations' do
      ssml = controller.t :have_many_cats
      ssml.should == RubySpeech::SSML.draw(language: 'en') do
        audio src: "file:///audio/en/have_many_cats.wav" do
          string 'I have quite a few cats'
        end
      end
    end

    it 'should generate proper SSML with only audio (no fallback text) translations' do
      ssml = controller.t :my_shirt_is_white
      ssml.should == RubySpeech::SSML.draw(language: 'en') do
        audio src: "file:///audio/en/my_shirt_is_white.wav" do
          string ''
        end
      end
    end

    it 'should generate proper SSML with only text (no audio) translations' do
      ssml = controller.t :many_people_out_today
      ssml.should == RubySpeech::SSML.draw(language: 'en') do
        string 'There are many people out today'
      end
    end

    it 'should generate a path to the audio prompt based on the requested locale' do
      ssml = controller.t :my_shirt_is_white, locale: 'it'
      ssml.should == RubySpeech::SSML.draw(language: 'it') do
        audio src: "file:///audio/it/la_mia_camicia_e_bianca.wav" do
          string ''
        end
      end
    end

    it 'should fall back to a text translation if the locale structure does not break out audio vs. tts' do
      ssml = controller.t :seventeen, locale: 'it'
      ssml.should == RubySpeech::SSML.draw(language: 'it') do
        string 'diciassette'
      end
    end
  end

  describe 'with fallback disabled, requesting a translation' do
    before do
      Adhearsion.config.i18n.fallback = false
      Adhearsion::Plugin.init_plugins
    end

    it 'should generate proper SSML with only audio (no text) translations' do
      ssml = controller.t :my_shirt_is_white
      ssml.should == RubySpeech::SSML.draw(language: 'en') do
        audio src: "file:///audio/en/my_shirt_is_white.wav"
      end
    end

    it 'should generate proper SSML with only text (no audio) translations' do
      ssml = controller.t :many_people_out_today
      ssml.should == RubySpeech::SSML.draw(language: 'en') do
        string 'There are many people out today'
      end
    end

    it 'should generate proper SSML with only audio translations when both are supplied' do
      ssml = controller.t :have_many_cats
      ssml.should == RubySpeech::SSML.draw(language: 'en') do
        audio src: "file:///audio/en/have_many_cats.wav"
      end
    end
  end
end
