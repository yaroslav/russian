# frozen_string_literal: true

require_relative "lib/russian/version"

Gem::Specification.new do |spec|
  spec.name = "russian"
  spec.version = Russian::VERSION::STRING

  spec.authors = ["Yaroslav Markin"]
  spec.description = "Russian language support for Ruby and Rails"
  spec.email = "yaroslav@markin.net"
  spec.extra_rdoc_files = ["README.md", "LICENSE", "CHANGELOG.md", "TODO.md"]
  spec.files = Dir.glob([
    "lib/**/*", "sig/**/*", "CHANGELOG.md", "Gemfile",
    "LICENSE", "Rakefile", "README.md", "russian.gemspec"
  ])
  spec.homepage = "https://github.com/yaroslav/russian"
  spec.license = "MIT"
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/yaroslav/russian/issues",
    "changelog_uri" => "https://github.com/yaroslav/russian/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://rubydoc.info/gems/russian",
    "homepage_uri" => "https://github.com/yaroslav/russian",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/yaroslav/russian"
  }
  spec.platform = Gem::Platform::RUBY
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.2"
  spec.summary = "Russian language support for Ruby and Rails"

  spec.add_dependency("i18n", ">= 1.14.8", "< 2")

  spec.add_development_dependency("bundler", ">= 2.4")
  spec.add_development_dependency("irb", ">= 1.15")
  spec.add_development_dependency("lefthook", "~> 2.1.4")
  spec.add_development_dependency("rake", ">= 13.0", "< 14")
  spec.add_development_dependency("rbs", "~> 3.10")
  spec.add_development_dependency("rdoc", ">= 6.10")
  spec.add_development_dependency("redcarpet", ">= 3.6")
  spec.add_development_dependency("rspec", "~> 3.13")
  spec.add_development_dependency("yard", "~> 0.9")
end
