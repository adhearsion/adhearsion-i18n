# encoding: utf-8

class AdhearsionI18n::Plugin < Adhearsion::Plugin
  init :i18n do
    ::Adhearsion::CallController.mixin ::AdhearsionI18n::CallControllerMethods

    config.locale_path.each do |dir|
      logger.debug "Adding #{dir} to the I18n load path"
      I18n.load_path += Dir["#{dir}/**/*.yml"]
    end

    logger.info "Adhearsion I18n loaded"
  end

  config :i18n do
    locale_path ["#{Adhearsion.root}/config/locales"], transform: Proc.new { |v| v.split ':' }, desc: <<-__
      List of directories from which to load locale data, colon-delimited
    __
    audio_path "#{Adhearsion.root}/audio", desc: <<-__
      Base path from which audio files can be found. May be a filesystem path or some other URL (like HTTP)
    __
  end
end
