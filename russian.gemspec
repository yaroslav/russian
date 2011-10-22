# -*- encoding: utf-8 -*-

$: << File.expand_path('../lib', __FILE__)
require 'russian/version'

Gem::Specification.new do |s|
  s.name = %q{russian}
  s.version = Russian::VERSION::STRING

  s.required_rubygems_version = '>= 1.3.5'
  s.authors = ["Yaroslav Markin"]
  s.autorequire = %q{russian}
  s.description = %q{Russian language support for Ruby and Rails}
  s.email = %q{yaroslav@markin.net}
  s.extra_rdoc_files = ["README.textile", "LICENSE", "CHANGELOG", "TODO"]
  s.files = Dir.glob("{lib,spec}/**/**") + %w(CHANGELOG Gemfile LICENSE Rakefile README.textile russian.gemspec TODO)
  s.platform = Gem::Platform::RUBY
  s.homepage = %q{http://github.com/yaroslav/russian/}
  s.require_paths = ["lib"]
  s.summary = %q{Russian language support for Ruby and Rails}

  s.add_dependency('i18n', '>= 0.5.0')

  s.add_development_dependency 'activesupport', '>= 3.0.0'
  s.add_development_dependency 'rspec', '~> 2.7.0'
end
