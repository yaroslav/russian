# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Russian do
  shared_examples "a locale-aware I18n proxy" do |method_name, target|
    it "forwards legacy option hashes with the Russian locale" do
      expect(I18n).to receive(target).with(argument, locale: described_class.locale, **options)

      described_class.public_send(method_name, argument, options)
    end

    it "forwards keyword arguments with the Russian locale" do
      expect(I18n).to receive(target).with(argument, locale: described_class.locale, **options)

      described_class.public_send(method_name, argument, **options)
    end
  end

  shared_examples "a public pluralization helper" do |method_name|
    let(:variants) { %w[вещь вещи вещей вещи] }

    it "selects representative Russian plural forms" do
      {
        1 => "вещь",
        2 => "вещи",
        5 => "вещей",
        3.14 => "вещи"
      }.each do |count, expected|
        expect(described_class.public_send(method_name, count, *variants)).to eq(expected)
      end
    end

    it "rejects non-numeric counters" do
      [nil, "вещь"].each do |value|
        expect { described_class.public_send(method_name, value, "вещь", "вещи", "вещей") }
          .to raise_error(ArgumentError)
      end
    end

    it "validates the number of pluralization variants" do
      invalid_variants = [
        [1],
        [1, "вещь"],
        [1, "вещь", "вещи"],
        [3.14, "вещь", "вещи", "вещей"]
      ]

      invalid_variants.each do |arguments|
        expect { described_class.public_send(method_name, *arguments) }.to raise_error(ArgumentError)
      end

      expect { described_class.public_send(method_name, 1, "вещь", "вещи", "вещей") }.not_to raise_error
      expect { described_class.public_send(method_name, 3.14, "вещь", "вещи", "вещей", "вещи") }.not_to raise_error
    end
  end

  describe "Russian locale identity" do
    it "defines the gem locale constant" do
      expect(described_class::LOCALE).to eq(:ru)
    end

    it "returns the locale through the public helper" do
      expect(described_class.locale).to eq(:ru)
    end
  end

  describe "I18n initialization" do
    around do |example|
      original_load_path = I18n.load_path.dup
      original_default_locale = I18n.default_locale
      original_enforce_available_locales = I18n.enforce_available_locales
      original_locale = I18n.locale

      example.run
    ensure
      I18n.load_path = original_load_path
      I18n.reload!
      I18n.enforce_available_locales = false
      I18n.default_locale = original_default_locale
      I18n.locale = original_locale
      I18n.enforce_available_locales = original_enforce_available_locales
    end

    it "preserves existing translations when reloading I18n" do
      I18n.load_path << File.join(__dir__, "fixtures", "en.yml")

      described_class.init_i18n

      expect(I18n.t(:foo, locale: :en)).to eq("bar")
    end

    it "preserves existing Russian overrides when reloading I18n" do
      I18n.load_path << File.join(__dir__, "fixtures", "ru.yml")

      described_class.init_i18n

      expect(I18n.t(:"date.formats.default", locale: :ru)).to eq("override")
    end

    it "does not change the default locale" do
      default_locale = I18n.default_locale

      described_class.init_i18n

      expect(I18n.default_locale).to eq(default_locale)
    end

    it "does not duplicate bundled locale files when called repeatedly" do
      described_class.init_i18n
      described_class.init_i18n

      locale_files = described_class.send(:locale_files)

      expect(I18n.load_path & locale_files).to match_array(locale_files)
      expect(I18n.load_path.count { |path| locale_files.include?(path) }).to eq(locale_files.size)
    end

    it "loads bundled locale files in a deterministic order" do
      expect(described_class.send(:locale_files)).to eq(described_class.send(:locale_files).sort)
    end
  end

  describe "translation helpers" do
    let(:argument) { :bar }
    let(:options) { {scope: :foo} }

    include_examples "a locale-aware I18n proxy", :t, :translate
    include_examples "a locale-aware I18n proxy", :translate, :translate
  end

  describe "localization helpers" do
    let(:argument) { instance_double(Time) }
    let(:options) { {format: "%d %B %Y"} }

    include_examples "a locale-aware I18n proxy", :l, :localize
    include_examples "a locale-aware I18n proxy", :localize, :localize
  end

  describe "strftime convenience helper" do
    let(:time) { instance_double(Time) }

    it "delegates an explicit format argument to localize" do
      expect(described_class).to receive(:localize).with(time, format: "%d %B %Y")

      described_class.strftime(time, "%d %B %Y")
    end

    it "uses the default format when no format is provided" do
      expect(described_class).to receive(:localize).with(time, format: :default)

      described_class.strftime(time)
    end

    it "accepts keyword format arguments" do
      expect(described_class).to receive(:localize).with(time, format: :long)

      described_class.strftime(time, format: :long)
    end

    it "accepts legacy option hashes" do
      expect(described_class).to receive(:localize).with(time, format: :long)

      described_class.strftime(time, {format: :long})
    end
  end

  describe "public pluralization helpers" do
    include_examples "a public pluralization helper", :p
    include_examples "a public pluralization helper", :pluralize
  end
end
