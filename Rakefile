require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec, :tag) do |t, task_args|
  unless task_args[:tag] == 'regression'
    t.rspec_opts = "--tag ~regression"
  end
end

task default: :spec
