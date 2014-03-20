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
        locale_files = Dir.glob(I18n.load_path)

        locale_errors = {}
        locale_files.each do |locale_file|
          # We only support YAML for now
          next unless locale_file =~ /\.ya?ml$/
          prompts = YAML.load File.read(locale_file)

          locale = prompts.keys.first
          prompts = prompts[locale]

          prompts.each_pair do |key, mapping|
            # Not all prompts will have audio files
            next unless mapping['audio']

            file = File.absolute_path "#{config['audio_path']}/#{locale}/#{mapping['audio']}"
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
