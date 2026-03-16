# frozen_string_literal: true

require "fileutils"
require "open3"
require "rbconfig"
require "tmpdir"
require_relative "spec_helper"

RSpec.describe "I18n-only integration", :integration do
  it "works with only i18n in the bundle and without Rails" do
    Dir.mktmpdir("russian-i18n-only") do |dir|
      FileUtils.cp(fixture_path("smoke.rb"), dir)
      File.write(File.join(dir, "Gemfile"), gemfile_contents)

      install_output, install_status = run_in_bundle(dir, "bundle", "install", "--quiet")
      expect(install_status.success?).to be(true), install_output

      smoke_output, smoke_status = run_in_bundle(dir, "bundle", "exec", RbConfig.ruby, "smoke.rb")
      expect(smoke_status.success?).to be(true), smoke_output
      expect(smoke_output).to include("ok")
      expect(smoke_output).to include("rails missing as expected")
    end
  end

  def run_in_bundle(dir, *command)
    Bundler.with_unbundled_env do
      Open3.capture2e(
        bundler_env(dir),
        *command,
        chdir: dir
      )
    end
  end

  def bundler_env(dir)
    {
      "BUNDLE_GEMFILE" => File.join(dir, "Gemfile")
    }
  end

  def fixture_path(name)
    File.expand_path("fixtures/i18n_only/#{name}", __dir__)
  end

  def gemfile_contents
    <<~GEMFILE
      source "https://rubygems.org"

      gem "i18n", ">= 1.14.8", "< 2"
      gem "russian", path: "#{File.expand_path("..", __dir__)}"
    GEMFILE
  end
end
