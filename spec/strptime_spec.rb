# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Russian do
  describe "localized strptime helpers" do
    it "parses common month names into Date" do
      expect(described_class.date_strptime("01 апреля 2011", "%d %B %Y")).to eq(Date.new(2011, 4, 1))
    end

    it "parses standalone month names into Date" do
      expect(described_class.date_strptime("Апрель 2011", "%B %Y")).to eq(Date.new(2011, 4, 1))
    end

    it "parses abbreviated month names into Date" do
      expect(described_class.date_strptime("01 апр. 2011", "%d %b %Y")).to eq(Date.new(2011, 4, 1))
    end

    it "parses weekday names case-insensitively" do
      expect(described_class.date_strptime("пЯтНиЦа, 01 АПРЕЛЯ 2011", "%A, %d %B %Y")).to eq(Date.new(2011, 4, 1))
    end

    it "supports non-zero-padded day directives that native Date.strptime accepts" do
      expect(described_class.date_strptime("1 апреля 2011", "%e %B %Y")).to eq(Date.new(2011, 4, 1))
    end

    it "leaves escaped percent literals intact" do
      expect(described_class.date_strptime("01 апреля % 2011", "%d %B %% %Y")).to eq(Date.new(2011, 4, 1))
    end

    it "delegates numeric-only parsing to Date.strptime" do
      expect(described_class.date_strptime("2011-04-01", "%Y-%m-%d")).to eq(Date.new(2011, 4, 1))
    end

    it "does not change the behavior of standard Date.strptime" do
      described_class.date_strptime("01 апреля 2011", "%d %B %Y")

      expect(Date.strptime("01 April 2011", "%d %B %Y")).to eq(Date.new(2011, 4, 1))
    end

    it "raises Date::Error for invalid localized input" do
      expect { described_class.date_strptime("01 абракадабра 2011", "%d %B %Y") }.to raise_error(Date::Error)
    end

    it "parses localized strings into Time" do
      time = described_class.time_strptime("пт, 01 апр. 2011 23:45:05 +0300", "%a, %d %b %Y %H:%M:%S %z")

      expect(time.year).to eq(2011)
      expect(time.month).to eq(4)
      expect(time.day).to eq(1)
      expect(time.hour).to eq(23)
      expect(time.min).to eq(45)
      expect(time.sec).to eq(5)
      expect(time.utc_offset).to eq(10_800)
    end

    it "parses localized strings into DateTime" do
      datetime = described_class.datetime_strptime("Пятница, 01 апреля 2011 23:45:05 +0300", "%A, %d %B %Y %H:%M:%S %z")

      expect(datetime).to eq(DateTime.new(2011, 4, 1, 23, 45, 5, "+03:00"))
    end
  end
end
