# -*- encoding: utf-8 -*- 

require File.dirname(__FILE__) + '/spec_helper'

describe Russian, "VERSION" do
  it "should be defined" do
    %w(MAJOR MINOR TINY STRING).each do |v|
      Russian::VERSION.const_defined?(v).should == true
    end
  end
end

describe Russian do
  describe "with locale" do
    it "should define :'ru' LOCALE" do
      Russian::LOCALE.should == :'ru'
    end

    it "should provide 'locale' proxy" do
      Russian.locale.should == Russian::LOCALE
    end
  end
  
  describe "with custom backend class" do
    it "should define i18n_backend_class" do
      Russian.i18n_backend_class.should == I18n::Backend::Advanced
    end
  end
  
  describe "during i18n initialization" do
    after(:each) do
      I18n.load_path = []
      Russian.init_i18n
    end

    it "should set I18n backend to an instance of a custom backend" do
      Russian.init_i18n
      I18n.backend.class.should == Russian.i18n_backend_class
    end
    
    it "should keep existing translations while switching backends" do
      I18n.load_path << File.join(File.dirname(__FILE__), 'fixtures', 'en.yml')
      Russian.init_i18n
      I18n.t(:foo, :locale => :'en').should == "bar"
    end
    
    it "should keep existing :ru translations while switching backends" do
      I18n.load_path << File.join(File.dirname(__FILE__), 'fixtures', 'ru.yml')
      Russian.init_i18n
      I18n.t(:'date.formats.default', :locale => :'ru').should == "override"
    end
    
    it "should set default locale to Russian locale" do
      Russian.init_i18n
      I18n.default_locale.should == Russian.locale
    end
  end
  
  describe "with localize proxy" do
    before(:all) do
      @time = mock(:time)
      @options = { :format => "%d %B %Y" }
    end
    
    %w(l localize).each do |method|
      it "'#{method}' should call I18n backend localize" do
        I18n.should_receive(:localize).with(@time, @options.merge({ :locale => Russian.locale }))
        Russian.send(method, @time, @options)
      end
    end
  end
  
  describe "with translate proxy" do
    before(:all) do
      @object = :bar
      @options = { :scope => :foo }
    end

    %w(t translate).each do |method|
      it "'#{method}' should call I18n backend translate" do
        I18n.should_receive(:translate).with(@object, @options.merge({ :locale => Russian.locale }))
        Russian.send(method, @object, @options)
      end
    end
  end
  
  describe "strftime" do
    before(:all) do
      @time = mock(:time)
    end

    it "should call localize with object and format" do
      format = "%d %B %Y"
      Russian.should_receive(:localize).with(@time, { :format => format })
      Russian.strftime(@time, format)
    end
    
    it "should call localize with object and default format when format is not specified" do
      Russian.should_receive(:localize).with(@time, { :format => :default })
      Russian.strftime(@time)
    end
  end
  
  describe "with pluralization" do
    %w(p pluralize).each do |method|
      it "'#{method}' should pluralize with variants given" do
        variants = %w(вещь вещи вещей вещи)
        
        Russian.send(method, 1, *variants).should == "вещь"
        Russian.send(method, 2, *variants).should == 'вещи'
        Russian.send(method, 3, *variants).should == 'вещи'
        Russian.send(method, 5, *variants).should == 'вещей'
        Russian.send(method, 10, *variants).should == 'вещей'
        Russian.send(method, 21, *variants).should == 'вещь'
        Russian.send(method, 29, *variants).should == 'вещей'
        Russian.send(method, 129, *variants).should == 'вещей'
        Russian.send(method, 131, *variants).should == 'вещь'
        Russian.send(method, 3.14, *variants).should == 'вещи'
      end
      
      it "should raise an exception when first parameter is not a number" do
        lambda { Russian.send(method, nil, "вещь", "вещи", "вещей") }.should raise_error(ArgumentError)
        lambda { Russian.send(method, "вещь", "вещь", "вещи", "вещей") }.should raise_error(ArgumentError)
      end
      
      it "should raise an exception when there are not enough variants" do
        lambda { Russian.send(method, 1) }.should raise_error(ArgumentError)
        lambda { Russian.send(method, 1, "вещь") }.should raise_error(ArgumentError)
        lambda { Russian.send(method, 1, "вещь", "вещи") }.should raise_error(ArgumentError)
        lambda { Russian.send(method, 1, "вещь", "вещи", "вещей") }.should_not raise_error(ArgumentError)
        lambda { Russian.send(method, 3.14, "вещь", "вещи", "вещей") }.should raise_error(ArgumentError)
        lambda { Russian.send(method, 3.14, "вещь", "вещи", "вещей", "вещи") }.should_not raise_error(ArgumentError)
      end
    end
  end
end
