require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec


# For development

task :console do
  exec "irb -r logzomg -I ./lib"
end

task :c => :console
