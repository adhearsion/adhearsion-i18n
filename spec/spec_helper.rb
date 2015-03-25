# encoding: utf-8

require 'adhearsion'
require 'adhearsion-i18n'

RSpec.configure do |config|
  config.color = true
  config.tty = true

  config.mock_with :rspec
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.backtrace_exclusion_patterns = [/rspec/]
end
