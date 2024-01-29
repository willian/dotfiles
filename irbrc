begin
  require 'pry-meta'
rescue LoadError
  warn '=> Unable to load pry-meta'
end

Pry.config.editor = ENV.fetch('EDITOR', 'nvim')

Pry.config.prompt = proc do |obj, _level, _|
  prompt = ''
  prompt << "#{Rails.version}@" if defined?(Rails)
  prompt << "#{RUBY_VERSION}"
  "#{prompt} (#{obj})> "
end

Pry.config.exception_handler = proc do |output, exception, _|
  output.puts "\e[31m#{exception.class}: #{exception.message}"
  output.puts "from #{exception.backtrace.first}\e[0m"
end

if defined?(Rails)
  require 'rails/console/app'
  require 'rails/console/helpers'
  TOPLEVEL_BINDING.eval('self').extend ::Rails::ConsoleMethods
end

Pry.config.print = proc do |output, value|
  Pry::Helpers::BaseHelpers
    .stagger_output("=> #{value.ai}", output)
end

Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'
