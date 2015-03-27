# encoding: utf-8
require 'yaml'

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
    audio_path "file://#{Adhearsion.root}/audio", desc: <<-__
      Base path from which audio files can be found. May be a filesystem path or some other URL (like HTTP)
    __
    fallback true, desc: <<-__
      Whether to include text for translations that provide both text & audio. True or false.
    __
  end

  tasks do
    namespace :i18n do
      desc "Validate configured audio prompt files exist"
      task :validate_files do
        config = Adhearsion.config.i18n
        locale_files = Dir.glob(I18n.load_path)

        locale_errors = {}
        checked_prompts = 0
        locale_files.each do |locale_file|
          # We only support YAML for now
          next unless locale_file =~ /\.ya?ml$/
          prompts = YAML.load File.read(locale_file)

          locale = prompts.keys.first
          prompts = prompts[locale]

          prompts.each_pair do |key, mapping|
            logger.trace "Checking i18n key #{key}"
            # Not all prompts will have audio files
            next unless mapping['audio']


            file = File.absolute_path "#{config['audio_path']}/#{locale}/#{mapping['audio']}"
            unless File.exist?(file)
              logger.warn "[#{locale}] Missing audio file: #{file}"
              locale_errors[locale] ||= 0
              locale_errors[locale] += 1
            end
            checked_prompts += 1
          end
        end

        if checked_prompts == 0
          logger.warn "No adhearsion-i18n prompts found. No files checked."
        else
          if locale_errors.keys.count > 0
            logger.error "Errors detected! Number of errors by locale:"
            locale_errors.each_pair do |locale, err_count|
              logger.error "[#{locale}]: #{err_count} missing prompts"
            end
          else
            logger.info "All configured prompt files successfully validated."
          end
        end
      end
    end
  end
end
