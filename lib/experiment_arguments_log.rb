#!/usr/bin/env ruby
require 'stringio'

def experiment_arguments_log
  if ENV['RUBY_EXPERIMENT_LOG']
    path = ENV['RUBY_EXPERIMENT_LOG']
  else
    path = 'ruby_experiment_log.txt'
  end

  File.open(path, 'a') do |output|

    date=Time.now.strftime("%Y-%m-%d %H:%M:%S")
    working_directory = ENV["PWD"]
    script_relative_path = $PROGRAM_NAME
    script_absolute_path = File.expand_path($PROGRAM_NAME)
    arguments = ARGV

    output.puts '    _  __  __  __  __  __  __  __  __  __  __  __  __  __  __  _'
    output.puts '     )(  )(  )(  )(  )(  )(  )(  )(  )(  )(  )(  )(  )(  )(  )( '
    output.puts '    (__)(__)(__)(__)(__)(__)(__)(__)(__)(__)(__)(__)(__)(__)(__)'
    output.puts
    output.puts "%s %s$ %s %s" % [date, working_directory, script_relative_path, arguments.map { |argument| argument.include?(' ') ? '"%s"'%[argument] : argument }.join(' ')]
    output.puts 'Date: %s' % [date]
    output.puts 'Working directory: %s' % [working_directory]
    output.puts 'Script path: %s' % [script_relative_path]
    output.puts 'Script absolute path: %s' % [script_absolute_path]
    output.puts 'Script access time: %s' % [File.ctime(script_absolute_path)]
    output.puts 'Script modification time: %s' % [File.mtime(script_absolute_path)]
    output.puts 'Arguments: %s' % arguments.to_s
    output.puts 'Git:'
    output.puts `git log -1 2>/dev/null`
    output.puts

    ARGV.each do |argument|
      begin
        File.open(argument) do |argument_file|
          output.puts 'File path: %s' % [argument]
          output.puts 'File absolute path: %s' % [File.expand_path(argument)]
          output.puts 'File access time: %s' % [argument_file.atime]
          output.puts 'File modification time: %s' % [argument_file.mtime]
          output.puts 'File size: %s' % [argument_file.size]
          if argument_file.file?
            output.puts 'Content:'
            5.times do
              output.puts argument_file.gets(1024) || break
            end
          end

          output.puts
        end
      rescue Errno::ENOENT
      end
    end

    output.puts

    if defined? $ruby_experiment_arguments_log
      output.puts 'STDOUT:'
      output.puts $ruby_experiment_arguments_log.string
      output.puts
    end
  end
end


def capture_stdout
  $ruby_experiment_arguments_log = StringIO.new

  def $stdout.write string
    ($ruby_experiment_arguments_log.write string) if $ruby_experiment_arguments_log.size < 1048576
    super
  end
end

