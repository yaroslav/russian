# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/spec_helper'

describe Russian do
  describe "with locale" do
    it "should define :'ru' LOCALE" do
      expect(Russian::LOCALE).to eq(:'ru')
    end

    it "should provide 'locale' proxy" do
      expect(Russian.locale).to eq(Russian::LOCALE)
    end
  end

  describe "during i18n initialization" do
    after(:each) do
      I18n.load_path = []
      Russian.init_i18n
    end

    it "should keep existing translations while switching backends" do
      I18n.load_path << File.join(File.dirname(__FILE__), 'fixtures', 'en.yml')
      Russian.init_i18n
      expect(I18n.t(:foo, :locale => :'en')).to eq("bar")
    end

    it "should keep existing :ru translations while switching backends" do
      I18n.load_path << File.join(File.dirname(__FILE__), 'fixtures', 'ru.yml')
      Russian.init_i18n
      expect(I18n.t(:'date.formats.default', :locale => :'ru')).to eq("override")
    end

    it "should NOT set default locale to Russian locale" do
      locale = I18n.default_locale
      Russian.init_i18n
      expect(I18n.default_locale).to eq(locale)
    end
  end

  describe "with localize proxy" do
    before do
      @time = double(:time)
      @options = { :format => "%d %B %Y" }
    end

    %w(l localize).each do |method|
      it "'#{method}' should call I18n backend localize" do
        expect(I18n).to receive(:localize).with(@time, @options.merge({ :locale => Russian.locale }))
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
        expect(I18n).to receive(:translate).with(@object, @options.merge({ :locale => Russian.locale }))
        Russian.send(method, @object, @options)
      end
    end
  end

  describe "strftime" do
    before do
      @time = double(:time)
    end

    it "should call localize with object and format" do
      format = "%d %B %Y"
      expect(Russian).to receive(:localize).with(@time, { :format => format })
      Russian.strftime(@time, format)
    end

    it "should call localize with object and default format when format is not specified" do
      expect(Russian).to receive(:localize).with(@time, { :format => :default })
      Russian.strftime(@time)
    end
  end

  describe "with pluralization" do
    %w(p pluralize).each do |method|
      it "'#{method}' should pluralize with variants given" do
        variants = %w(вещь вещи вещей вещи)

        expect(Russian.send(method, 1, *variants)).to eq("вещь")
        expect(Russian.send(method, 2, *variants)).to eq('вещи')
        expect(Russian.send(method, 3, *variants)).to eq('вещи')
        expect(Russian.send(method, 5, *variants)).to eq('вещей')
        expect(Russian.send(method, 10, *variants)).to eq('вещей')
        expect(Russian.send(method, 21, *variants)).to eq('вещь')
        expect(Russian.send(method, 29, *variants)).to eq('вещей')
        expect(Russian.send(method, 129, *variants)).to eq('вещей')
        expect(Russian.send(method, 131, *variants)).to eq('вещь')
        expect(Russian.send(method, 3.14, *variants)).to eq('вещи')
      end

      it "should raise an exception when first parameter is not a number" do
        expect { Russian.send(method, nil, "вещь", "вещи", "вещей") }.to raise_error(ArgumentError)
        expect { Russian.send(method, "вещь", "вещь", "вещи", "вещей") }.to raise_error(ArgumentError)
      end

      it "should raise an exception when there are not enough variants" do
        expect { Russian.send(method, 1) }.to raise_error(ArgumentError)
        expect { Russian.send(method, 1, "вещь") }.to raise_error(ArgumentError)
        expect { Russian.send(method, 1, "вещь", "вещи") }.to raise_error(ArgumentError)
        expect { Russian.send(method, 1, "вещь", "вещи", "вещей") }.not_to raise_error
        expect { Russian.send(method, 3.14, "вещь", "вещи", "вещей") }.to raise_error(ArgumentError)
        expect { Russian.send(method, 3.14, "вещь", "вещи", "вещей", "вещи") }.not_to raise_error
      end
    end
  end
end
