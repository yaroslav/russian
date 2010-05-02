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
      l(@date).should == "01.12.1985"
    end

    it "should use short format" do
      l(@date, :format => :short).should == "01 дек."
    end

    it "should use long format" do
      l(@date, :format => :long).should == "01 декабря 1985"
    end
  end
  
  describe "with date day names" do
    it "should use day names" do
      l(@date, :format => "%d %B (%A)").should == "01 декабря (воскресенье)"
      l(@date, :format => "%d %B %Y года было %A").should == "01 декабря 1985 года было воскресенье"
    end

    it "should use standalone day names" do
      l(@date, :format => "%A").should == "Воскресенье"
      l(@date, :format => "%A, %d %B").should == "Воскресенье, 01 декабря"
    end
    
    it "should use abbreviated day names" do
      l(@date, :format => "%a").should == "Вс"
      l(@date, :format => "%a, %d %b %Y").should == "Вс, 01 дек. 1985"
    end
  end
  
  describe "with month names" do
    it "should use month names" do
      l(@date, :format => "%d %B").should == "01 декабря"
      l(@date, :format => "%e %B %Y").should == " 1 декабря 1985"
      l(@date, :format => "<b>%d</b> %B").should == "<b>01</b> декабря"
      l(@date, :format => "<strong>%e</strong> %B %Y").should == "<strong> 1</strong> декабря 1985"
      l(@date, :format => "А было тогда %eе число %B %Y").should == "А было тогда  1е число декабря 1985"
    end
    
    it "should use standalone month names" do
      l(@date, :format => "%B").should == "Декабрь"
      l(@date, :format => "%B %Y").should == "Декабрь 1985"
    end
    
    it "should use abbreviated month names" do
      @date = Date.parse("1985-03-01")
      l(@date, :format => "%d %b").should == "01 марта"
      l(@date, :format => "%e %b %Y").should == " 1 марта 1985"
      l(@date, :format => "<b>%d</b> %b").should == "<b>01</b> марта"
      l(@date, :format => "<strong>%e</strong> %b %Y").should == "<strong> 1</strong> марта 1985"
    end
    
    it "should use standalone abbreviated month names" do
      @date = Date.parse("1985-03-01")
      l(@date, :format => "%b").should == "март"
      l(@date, :format => "%b %Y").should == "март 1985"
    end
  end

  it "should define default date components order: day, month, year" do
    I18n.backend.translate(Russian.locale, :"date.order").should == [:day, :month, :year]
  end

  describe "with time formats" do
    it "should use default format" do
      l(@time).should =~ /^Вс, 01 дек. 1985, 16:05:00/
    end

    it "should use short format" do
      l(@time, :format => :short).should == "01 дек., 16:05"
    end

    it "should use long format" do
      l(@time, :format => :long).should == "01 декабря 1985, 16:05"
    end
    
    it "should define am and pm" do
      I18n.backend.translate(Russian.locale, :"time.am").should_not be_nil
      I18n.backend.translate(Russian.locale, :"time.pm").should_not be_nil
    end
  end

  protected
    def l(object, options = {})
      I18n.l(object, options.merge( { :locale => Russian.locale }))
    end
end
