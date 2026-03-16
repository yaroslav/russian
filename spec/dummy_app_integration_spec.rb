# frozen_string_literal: true

require "rails"
require_relative "dummy/config/environment"
require_relative "spec_helper"

RSpec.describe "Dummy Rails application integration", :integration do
  around do |example|
    original_locale = I18n.locale
    I18n.locale = Russian.locale
    example.run
  ensure
    I18n.locale = original_locale
  end

  it "boots the dummy app and installs the railtie automatically" do
    expect(Rails.application).to be_a(Dummy::Application)
    expect(defined?(Russian::Railtie)).to eq("constant")
    expect(ActionView::Helpers::DateTimeSelector.instance_method(:translated_month_names).owner).to eq(
      Russian::ActionViewExt::Helpers::DateTimeSelectorPatch
    )
  end

  it "suppresses attribute names in full_messages inside the dummy app" do
    record = DummyRecord.new.tap(&:valid?)

    expect(record.errors.full_messages).to eq(["Нужно принять лицензию"])
    expect(record.errors.full_messages_for(:license_accepted)).to eq(["Нужно принять лицензию"])
    expect(record.errors.full_message(:license_accepted, "^Нужно принять лицензию")).to eq("Нужно принять лицензию")
  end

  it "supports parameterize via I18n transliteration inside the dummy app" do
    expect("Дональд Кнут".parameterize).to eq("donald-knut")
  end
end
