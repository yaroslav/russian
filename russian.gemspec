# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{russian}
  s.version = "0.2.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yaroslav Markin"]
  s.autorequire = %q{russian}
  s.date = %q{2010-05-05}
  s.description = %q{Russian language support for Ruby and Rails}
  s.email = %q{yaroslav@markin.net}

  s.extra_rdoc_files = ["README.textile", "LICENSE", "CHANGELOG", "TODO"]
  s.files = Dir.glob("[A-Z]*") + Dir.glob("*.{c,h,rb}") + Dir.glob("{examples,lib}/**/*")
  s.test_files = Dir.glob('spec/**')

  s.homepage = %q{http://github.com/yaroslav/russian/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Russian language support for Ruby and Rails}

  if s.respond_to? :specification_version= then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
  end
end
