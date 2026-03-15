# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe I18n, "Russian Date/Time localization" do
  before do
    Russian.init_i18n
  end

  let(:date) { Date.parse("1985-12-01") }
  let(:march_date) { Date.parse("1985-03-01") }
  let(:time) { Time.local(1985, 12, 1, 16, 5) }

  describe "with date formats" do
    it "uses named date formats" do
      [
        [nil, "01.12.1985"],
        [:short, "01 дек."],
        [:long, "01 декабря 1985"]
      ].each do |format, expected|
        localized = format ? l(date, format: format) : l(date)

        expect(localized).to eq(expected)
      end
    end
  end

  describe "with date day names" do
    it "uses day names" do
      {
        "%d %B (%A)" => "01 декабря (воскресенье)",
        "%d %B %Y года было %A" => "01 декабря 1985 года было воскресенье"
      }.each do |format, expected|
        expect(l(date, format: format)).to eq(expected)
      end
    end

    it "uses standalone day names" do
      {
        "%A" => "Воскресенье",
        "%A, %d %B" => "Воскресенье, 01 декабря"
      }.each do |format, expected|
        expect(l(date, format: format)).to eq(expected)
      end
    end

    it "uses abbreviated day names" do
      {
        "%a" => "Вс",
        "%a, %d %b %Y" => "Вс, 01 дек. 1985"
      }.each do |format, expected|
        expect(l(date, format: format)).to eq(expected)
      end
    end
  end

  describe "with month names" do
    it "resolves standalone month name arrays without format context" do
      expect(I18n.t(:"date.month_names", locale: Russian.locale)[12]).to eq("Декабрь")
      expect(I18n.t(:"date.abbr_month_names", locale: Russian.locale)[3]).to eq("март")
    end

    it "uses month names" do
      {
        "%d %B" => "01 декабря",
        "%-d %B" => "1 декабря",
        "%1d %B" => "1 декабря",
        "%2d %B" => "01 декабря",
        "%e %B %Y" => " 1 декабря 1985",
        "<b>%d</b> %B" => "<b>01</b> декабря",
        "<strong>%e</strong> %B %Y" => "<strong> 1</strong> декабря 1985",
        "А было тогда %eе число %B %Y" => "А было тогда  1е число декабря 1985"
      }.each do |format, expected|
        expect(l(date, format: format)).to eq(expected)
      end
    end

    it "uses standalone month names" do
      {
        "%B" => "Декабрь",
        "%B %Y" => "Декабрь 1985"
      }.each do |format, expected|
        expect(l(date, format: format)).to eq(expected)
      end
    end

    it "uses abbreviated month names" do
      {
        "%d %b" => "01 марта",
        "%e %b %Y" => " 1 марта 1985",
        "<b>%d</b> %b" => "<b>01</b> марта",
        "<strong>%e</strong> %b %Y" => "<strong> 1</strong> марта 1985"
      }.each do |format, expected|
        expect(l(march_date, format: format)).to eq(expected)
      end
    end

    it "uses standalone abbreviated month names" do
      {
        "%b" => "март",
        "%b %Y" => "март 1985"
      }.each do |format, expected|
        expect(l(march_date, format: format)).to eq(expected)
      end
    end
  end

  it "defines the default date components order as day, month, year" do
    expect(I18n.backend.translate(Russian.locale, :"date.order")).to eq(%i[day month year])
  end

  describe "with time formats" do
    it "uses named time formats" do
      expect(l(time)).to match(/^Вс, 01 дек. 1985, 16:05:00/)

      {
        short: "01 дек., 16:05",
        long: "01 декабря 1985, 16:05"
      }.each do |format, expected|
        expect(l(time, format: format)).to eq(expected)
      end
    end

    it "defines am and pm" do
      %i[am pm].each do |period|
        expect(I18n.backend.translate(Russian.locale, :"time.#{period}")).to be_a(String)
      end
    end
  end

  def l(object, **options)
    I18n.l(object, **options.merge(locale: Russian.locale))
  end
end
