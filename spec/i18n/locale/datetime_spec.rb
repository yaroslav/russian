# -*- encoding: utf-8 -*- 

require File.dirname(__FILE__) + '/../../spec_helper'

describe I18n, "Russian Date/Time localization" do
  before(:all) do
    Russian.init_i18n
    @date = Date.parse("1985-12-01")
    @time = Time.local(1985, 12, 01, 16, 05)
  end

  describe "with date formats" do
    it "should use default format" do
      expect(l(@date)).to eq("01.12.1985")
    end

    it "should use short format" do
      expect(l(@date, :format => :short)).to eq("01 дек.")
    end

    it "should use long format" do
      expect(l(@date, :format => :long)).to eq("01 декабря 1985")
    end
  end

  describe "with date day names" do
    it "should use day names" do
      expect(l(@date, :format => "%d %B (%A)")).to eq("01 декабря (воскресенье)")
      expect(l(@date, :format => "%d %B %Y года было %A")).to eq("01 декабря 1985 года было воскресенье")
    end

    it "should use standalone day names" do
      expect(l(@date, :format => "%A")).to eq("Воскресенье")
      expect(l(@date, :format => "%A, %d %B")).to eq("Воскресенье, 01 декабря")
    end

    it "should use abbreviated day names" do
      expect(l(@date, :format => "%a")).to eq("Вс")
      expect(l(@date, :format => "%a, %d %b %Y")).to eq("Вс, 01 дек. 1985")
    end
  end

  describe "with month names" do
    it "should use month names" do
      expect(l(@date, :format => "%d %B")).to eq("01 декабря")
      expect(l(@date, :format => "%-d %B")).to eq("1 декабря")

      if RUBY_VERSION > "1.9.2"
        expect(l(@date, :format => "%1d %B")).to eq("1 декабря")
        expect(l(@date, :format => "%2d %B")).to eq("01 декабря")
      end

      expect(l(@date, :format => "%e %B %Y")).to eq(" 1 декабря 1985")
      expect(l(@date, :format => "<b>%d</b> %B")).to eq("<b>01</b> декабря")
      expect(l(@date, :format => "<strong>%e</strong> %B %Y")).to eq("<strong> 1</strong> декабря 1985")
      expect(l(@date, :format => "А было тогда %eе число %B %Y")).to eq("А было тогда  1е число декабря 1985")
    end

    it "should use standalone month names" do
      expect(l(@date, :format => "%B")).to eq("Декабрь")
      expect(l(@date, :format => "%B %Y")).to eq("Декабрь 1985")
    end

    it "should use abbreviated month names" do
      @date = Date.parse("1985-03-01")
      expect(l(@date, :format => "%d %b")).to eq("01 марта")
      expect(l(@date, :format => "%e %b %Y")).to eq(" 1 марта 1985")
      expect(l(@date, :format => "<b>%d</b> %b")).to eq("<b>01</b> марта")
      expect(l(@date, :format => "<strong>%e</strong> %b %Y")).to eq("<strong> 1</strong> марта 1985")
    end

    it "should use standalone abbreviated month names" do
      @date = Date.parse("1985-03-01")
      expect(l(@date, :format => "%b")).to eq("март")
      expect(l(@date, :format => "%b %Y")).to eq("март 1985")
    end
  end

  it "should define default date components order: day, month, year" do
    expect(I18n.backend.translate(Russian.locale, :"date.order")).to eq([:day, :month, :year])
  end

  describe "with time formats" do
    it "should use default format" do
      expect(l(@time)).to match(/^Вс, 01 дек. 1985, 16:05:00/)
    end

    it "should use short format" do
      expect(l(@time, :format => :short)).to eq("01 дек., 16:05")
    end

    it "should use long format" do
      expect(l(@time, :format => :long)).to eq("01 декабря 1985, 16:05")
    end

    it "should define am and pm" do
      expect(I18n.backend.translate(Russian.locale, :"time.am")).not_to be_nil
      expect(I18n.backend.translate(Russian.locale, :"time.pm")).not_to be_nil
    end
  end

  protected
    def l(object, options = {})
      I18n.l(object, options.merge( { :locale => Russian.locale }))
    end
end
