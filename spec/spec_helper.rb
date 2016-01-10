$TESTING=true
require 'russian'
require 'active_record'
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }
