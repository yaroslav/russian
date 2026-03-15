# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Russian, "loading locales" do
  before(:all) do
    Russian.init_i18n
  end

  %w[
    date.formats.default
    date.formats.short
    date.formats.long
    date.day_names
    date.common_day_names
    date.standalone_day_names
    date.abbr_day_names
    date.common_abbr_day_names
    date.standalone_abbr_day_names
    date.month_names
    date.common_month_names
    date.standalone_month_names
    date.abbr_month_names
    date.common_abbr_month_names
    date.standalone_abbr_month_names
    date.order
    time.formats.default
    time.formats.short
    time.formats.long
    time.am
    time.pm
    datetime.distance_in_words.less_than_x_seconds.one
    datetime.distance_in_words.x_seconds.one
    datetime.distance_in_words.x_days.one
    datetime.distance_in_words.x_months.one
    datetime.distance_in_words.almost_x_years.one
    datetime.distance_in_words.over_x_years.one
    datetime.distance_in_words.x_years.one
    datetime.prompts.year
    datetime.prompts.second
    errors.format
    errors.messages.in
    errors.messages.model_invalid
    errors.messages.other_than
    errors.messages.present
    errors.messages.record_invalid
    errors.messages.required
    activerecord.errors.full_messages.format
    activerecord.errors.messages.record_invalid
    activerecord.errors.messages.restrict_dependent_destroy.has_one
    activerecord.errors.messages.restrict_dependent_destroy.has_many
    helpers.select.prompt
    helpers.submit.create
    helpers.submit.update
    helpers.submit.submit
    support.array.sentence_connector
    support.array.words_connector
    number.format.round_mode
    number.currency.format.separator
    number.currency.format.negative_format
    number.human.storage_units.units.byte.one
    number.human.storage_units.units.eb
    number.human.storage_units.units.pb
    number.human.decimal_units.units.quadrillion.one
    number.percentage.format.format
  ].each do |key|
    it "defines #{key} in Russian translations" do
      expect(lookup(key)).not_to be_nil
    end
  end

  it "loads pluralization rules" do
    expect(lookup(:"i18n.plural.rule")).to be_a(Proc)
  end

  it "loads transliteration rules" do
    expect(lookup(:"i18n.transliterate.rule")).to be_a(Proc)
  end

  it "defines correct odd/even validation messages" do
    expect(I18n.t(:"errors.messages.odd", locale: Russian.locale)).to eq("может иметь лишь нечетное значение")
    expect(I18n.t(:"errors.messages.even", locale: Russian.locale)).to eq("может иметь лишь четное значение")
  end

  def lookup(*args)
    I18n.backend.send(:lookup, Russian.locale, *args)
  end
end
