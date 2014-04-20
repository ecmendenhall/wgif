require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec, :tag) do |t, task_args|
  if task_args[:tag] == 'unit'
    t.rspec_opts = "--tag ~integration"
  end
end

task default: :spec
