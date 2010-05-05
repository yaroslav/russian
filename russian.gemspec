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
  s.files = ["LICENSE", "README.textile", "Rakefile", "CHANGELOG", "TODO", "init.rb", "lib/russian", "lib/russian/action_view_ext", "lib/russian/action_view_ext/helpers", "lib/russian/action_view_ext/helpers/date_helper.rb", "lib/russian/active_record_ext", "lib/russian/active_record_ext/custom_error_message.rb", "lib/russian/active_support_ext", "lib/russian/active_support_ext/parameterize.rb", "lib/russian/backend", "lib/russian/backend/advanced.rb", "lib/russian/locale", "lib/russian/locale/actionview.yml", "lib/russian/locale/activerecord.yml", "lib/russian/locale/activesupport.yml", "lib/russian/locale/datetime.yml", "lib/russian/locale/pluralize.rb", "lib/russian/transliteration.rb", "lib/russian.rb", "lib/vendor", "lib/vendor/i18n", "lib/vendor/i18n/i18n.gemspec", "lib/vendor/i18n/lib", "lib/vendor/i18n/lib/i18n", "lib/vendor/i18n/lib/i18n/backend", "lib/vendor/i18n/lib/i18n/backend/simple.rb", "lib/vendor/i18n/lib/i18n/exceptions.rb", "lib/vendor/i18n/lib/i18n.rb", "lib/vendor/i18n/MIT-LICENSE", "lib/vendor/i18n/Rakefile", "lib/vendor/i18n/README.textile", "lib/vendor/i18n/test", "lib/vendor/i18n/test/all.rb", "lib/vendor/i18n/test/i18n_exceptions_test.rb", "lib/vendor/i18n/test/i18n_test.rb", "lib/vendor/i18n/test/locale", "lib/vendor/i18n/test/locale/en.rb", "lib/vendor/i18n/test/locale/en.yml", "lib/vendor/i18n/test/simple_backend_test.rb", "lib/vendor/i18n_label", "lib/vendor/i18n_label/init.rb", "lib/vendor/i18n_label/install.rb", "lib/vendor/i18n_label/lib", "lib/vendor/i18n_label/lib/i18n_label.rb", "lib/vendor/i18n_label/Rakefile", "lib/vendor/i18n_label/README.textile", "lib/vendor/i18n_label/spec", "lib/vendor/i18n_label/spec/i18n_label_spec.rb", "lib/vendor/i18n_label/spec/spec_helper.rb", "lib/vendor/i18n_label/tasks", "lib/vendor/i18n_label/tasks/i18n_label_tasks.rake", "lib/vendor/i18n_label/uninstall.rb", "spec/fixtures", "spec/fixtures/en.yml", "spec/fixtures/ru.yml", "spec/i18n", "spec/i18n/locale", "spec/i18n/locale/datetime_spec.rb", "spec/i18n/locale/pluralization_spec.rb", "spec/locale_spec.rb", "spec/russian_spec.rb", "spec/spec_helper.rb", "spec/transliteration_spec.rb"]
  s.homepage = %q{http://github.com/yaroslav/russian/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Russian language support for Ruby and Rails}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
