# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"
require "yard"

desc "Run specs"
RSpec::Core::RakeTask.new(:spec)

desc "Build YARD documentation"
YARD::Rake::YardocTask.new(:yard)

desc "Run lint and specs"
task ci: %i[standard spec]

task default: %i[standard spec]
