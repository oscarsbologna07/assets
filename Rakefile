# frozen_string_literal: true

require "rake"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.libs.push "test"

  if ENV["TRAVIS"]
    t.verbose = false
    t.warning = false
  end
end

RSpec::Core::RakeTask.new(:spec)
namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |task|
    file_list = FileList["spec/**/*_spec.rb"]
    file_list = file_list.exclude("spec/{integration,isolation}/**/*_spec.rb")

    task.pattern = file_list
  end

  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task["spec:unit"].invoke
  end
end
task default: "spec"
