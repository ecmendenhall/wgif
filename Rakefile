require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec, :tag) do |t, task_args|
  unless task_args[:tag] == 'integration'
    t.rspec_opts = "--tag ~integration"
  end
end

task default: :spec
