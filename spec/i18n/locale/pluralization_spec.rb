# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe I18n, "Russian pluralization" do
  let(:translations) do
    %w[one few many other].to_h { |key| [key.to_sym, key] }
  end

  let(:backend) { I18n.backend }

  let(:cases) do
    {
      1 => "one",
      2 => "few",
      3 => "few",
      5 => "many",
      10 => "many",
      11 => "many",
      21 => "one",
      29 => "many",
      131 => "one",
      1.31 => "other",
      2.31 => "other",
      3.31 => "other"
    }
  end

  it "pluralizes correctly", :aggregate_failures do
    cases.each do |count, expected|
      expect(backend.send(:pluralize, :ru, translations, count))
        .to eq(expected), "expected #{count.inspect} to pluralize as #{expected.inspect}"
    end
  end
end
