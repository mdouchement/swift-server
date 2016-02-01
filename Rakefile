require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = '--format pretty'
end

at_exit do
  # Clean zombie processes
  system("kill $(ps aux | grep 'cucumber --format pretty' | awk '{print $2}')") if RUBY_PLATFORM.include?('linux')
end
