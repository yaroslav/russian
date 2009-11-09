# -*- encoding: utf-8 -*- 

require File.dirname(__FILE__) + '/spec_helper'

describe Russian, "loading locales" do
  before(:all) do
    Russian.init_i18n
  end
  
  %w(
    date.formats.default
    date.formats.short
    date.formats.long
    date.day_names
    date.standalone_day_names
    date.abbr_day_names
    date.month_names
    date.standalone_month_names
    date.abbr_month_names
    date.standalone_abbr_month_names
    date.order
    
    time.formats.default
    time.formats.short
    time.formats.long
    time.am
    time.pm
  ).each do |key| 
    it "should define '#{key}' in datetime translations" do
      lookup(key).should_not be_nil
    end
  end
  
  it "should load pluralization rules" do
    lookup(:"pluralize").should_not be_nil
    lookup(:"pluralize").is_a?(Proc).should be_true
  end

  %w(
    number.format.separator
    number.format.delimiter
    number.format.precision
    number.currency.format.format
    number.currency.format.unit
    number.currency.format.separator
    number.currency.format.delimiter
    number.currency.format.precision
    number.percentage.format.delimiter
    number.precision.format.delimiter
    number.human.format.delimiter
    number.human.format.precision
    number.human.storage_units
    
    datetime.distance_in_words.half_a_minute
    datetime.distance_in_words.less_than_x_seconds
    datetime.distance_in_words.x_seconds
    datetime.distance_in_words.less_than_x_minutes
    datetime.distance_in_words.x_minutes
    datetime.distance_in_words.about_x_hours
    datetime.distance_in_words.x_days
    datetime.distance_in_words.about_x_months
    datetime.distance_in_words.x_months
    datetime.distance_in_words.about_x_years
    datetime.distance_in_words.over_x_years
    datetime.distance_in_words.almost_x_years
    
    datetime.prompts.year
    datetime.prompts.month
    datetime.prompts.day
    datetime.prompts.hour
    datetime.prompts.minute
    datetime.prompts.second
    
    activerecord.errors.template.header
    activerecord.errors.template.body
    
    support.select.prompt
  ).each do |key| 
    it "should define '#{key}' in actionview translations" do
      lookup(key).should_not be_nil
    end
  end

  %w(
    activerecord.errors.messages.inclusion
    activerecord.errors.messages.exclusion
    activerecord.errors.messages.invalid
    activerecord.errors.messages.confirmation
    activerecord.errors.messages.accepted
    activerecord.errors.messages.empty
    activerecord.errors.messages.blank
    activerecord.errors.messages.too_long
    activerecord.errors.messages.too_short
    activerecord.errors.messages.wrong_length
    activerecord.errors.messages.taken
    activerecord.errors.messages.not_a_number
    activerecord.errors.messages.greater_than
    activerecord.errors.messages.greater_than_or_equal_to
    activerecord.errors.messages.equal_to
    activerecord.errors.messages.less_than
    activerecord.errors.messages.less_than_or_equal_to
    activerecord.errors.messages.odd
    activerecord.errors.messages.even
    activerecord.errors.messages.record_invalid

    activerecord.errors.full_messages.format
  ).each do |key| 
    it "should define '#{key}' in activerecord translations" do
      lookup(key).should_not be_nil
    end
  end
  
  %w(
    support.array.sentence_connector
    support.array.skip_last_comma
    
    support.array.words_connector
    support.array.two_words_connector
    support.array.last_word_connector
  ).each do |key| 
    it "should define '#{key}' in activesupport translations" do
      lookup(key).should_not be_nil
    end
  end
  
  def lookup(*args)
    I18n.backend.send(:lookup, Russian.locale, *args)
  end
end
