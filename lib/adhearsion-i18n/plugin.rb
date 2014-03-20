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
    audio_path "#{Adhearsion.root}/audio", desc: <<-__
      Base path from which audio files can be found. May be a filesystem path or some other URL (like HTTP)
    __
  end

  tasks do
    namespace :i18n do
      desc "Validate configured audio prompt files exist"
      task :validate_files do
        ahn_root = "#{File.dirname(__FILE__)}/../.."
        locales_dir = "#{ahn_root}/config/locales"
        locales = Dir.glob("#{locales_dir}/*").map { |localedir| File.basename localedir }

        audio_dir = "#{ahn_root}/audio"

        locale_errors = {}
        locales.each do |locale|
          prompts = YAML.load File.read("#{locales_dir}/#{locale}/#{locale}.yml")
          prompts = prompts[locale]
          unless prompts
            puts "Unable to find locale data for #{locale}"
            next
          end

          prompts.each_pair do |key, mapping|
            file = File.absolute_path "#{audio_dir}/#{locale}/#{mapping['audio']}"
            unless File.exist?(file)
              puts "[#{locale}] Missing audio file: #{file}"
              locale_errors[locale] ||= 0
              locale_errors[locale] += 1
            end
          end
        end

        if locale_errors.keys.count > 0
          puts "Errors detected! Number of errors by locale:"
          locale_errors.each_pair do |locale, err_count|
            puts "[#{locale}]: #{err_count} missing prompts"
          end
        else
          puts "All configured prompt files successfully validated."
        end
      end
    end
  end
end
