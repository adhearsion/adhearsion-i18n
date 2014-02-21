# encoding: utf-8

class AdhearsionI18n::Plugin < Adhearsion::Plugin
  init :i18n do
    ::Adhearsion::CallController.mixin ::Adhearsion::I18n::CallControllerMethods
    logger.info "Adhearsion I18n loaded"
  end

  config :i18n do
    locale_path ["#{Adhearsion.root}/config/locales"], transform: Proc.new { |v| v.split ':' }, desc: <<-__
      List of directories from which to load locale data, colon-delimited
    __
  end
end
