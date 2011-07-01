require 'rubygems'
require 'rake/gempackagetask'

begin
  require 'rspec/core/rake_task'
rescue
  begin
  require 'spec/rake/spectask'
  rescue
  end
end

if defined? Rake::GemPackageTask
  gemspec = eval(File.read('russian.gemspec'))

  Rake::GemPackageTask.new(gemspec) do |pkg|
    pkg.gem_spec = gemspec
  end

  desc "install the gem locally"
  task :install => [:package] do
    sh %{gem install pkg/#{gemspec.name}-#{gemspec.version}}
  end
end

task :default => :spec

desc "Run specs"

if defined? RSpec
  RSpec::Core::RakeTask.new(:spec) do |t|
  end
elsif defined? Spec
  Spec::Rake::SpecTask.new do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = %w(-fs --color)
  end
end
