#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec"
require "rspec/core/rake_task"

namespace :spec do
  desc "Run the integration tests. Requires ArangoDB."
  RSpec::Core::RakeTask.new(:integration) do |spec|
    spec.rspec_opts = "--require integration/arango_helper.rb"
    spec.pattern = "spec/integration/*_spec.rb"
  end

  desc "Run the unit tests"
  RSpec::Core::RakeTask.new(:unit) do |spec|
    spec.pattern = "spec/unit/*_spec.rb"
  end

  desc "Run all tests. Requires ArangoDB"
  task :all => [:integration, :unit]
end

desc "check if gems are up to date"
task :dependencies do
  dependency_status = `bundle outdated`
  if dependency_status.include? "up to date"
    puts "Dependencies up to date."
  else
    puts dependency_status
    exit(1)
  end
end

namespace :yard do
  desc "generate the documentation"
  task :generate do
    `yard`
  end

  desc "start the documentation server on port 8808"
  task :server do
    `yard server --reload`
  end

  desc "get statistics on the yard documentation"
  task :stats do
    `yard stats`
  end
end

desc "Run Unit Tests - no ArangoDB required"
task :ci => ["spec:unit"]

desc "Run all tests - ArangoDB required"
task :default => ["spec:all"]
