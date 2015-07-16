require 'experiment_arguments_log'

capture_stdout

at_exit do
  experiment_arguments_log
end
