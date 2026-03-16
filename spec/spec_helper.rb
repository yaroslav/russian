# frozen_string_literal: true

require "date"
require_relative "../lib/russian"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expect_with(:rspec) do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with(:rspec) do |mocks|
    mocks.syntax = :expect
  end
end
