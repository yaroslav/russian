source :rubygems

gem 'rake'
gem 'i18n', '>= 0.5.0'
gem 'rspec', '~> 2.7.0'


if RUBY_PLATFORM == 'java'
else
end

platforms :jruby do
  gem 'unicode_utils', '1.4.0'
end

platforms :ruby, :mswin, :mingw do
  gem 'unicode', '0.4.4'
end

# Rails 3+
gem 'activesupport', '~> 3.0.0'