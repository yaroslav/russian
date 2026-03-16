# frozen_string_literal: true

require "open3"
require "rbconfig"
require_relative "spec_helper"

RSpec.describe "Rails integration", :integration do
  it "applies Rails patches when russian is required before framework components inside Rails" do
    run_fixture("load_order_in_rails.rb")
  end

  it "can patch late-loaded Rails components when install! is called again" do
    run_fixture("late_install_in_rails.rb")
  end

  it "does not apply Rails-only patches outside Rails" do
    run_fixture("outside_rails.rb")
  end

  def run_fixture(name)
    output, status = Open3.capture2e(RbConfig.ruby, fixture_path(name))

    expect(status.success?).to be(true), output
  end

  def fixture_path(name)
    File.expand_path("fixtures/rails_integration/#{name}", __dir__)
  end
end
