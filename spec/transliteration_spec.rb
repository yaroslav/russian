# -*- encoding: utf-8 -*- 

require File.dirname(__FILE__) + '/spec_helper'

describe Russian do
  describe "transliteration" do
    def t(str)
      Russian::transliterate(str)
    end

    %w(transliterate translit).each do |method|
      it "'#{method}' method should perform transliteration" do
        str = mock(:str)
        Russian::Transliteration.should_receive(:transliterate).with(str)
        Russian.send(method, str)
      end
    end

    # These tests are from rutils, <http://rutils.rubyforge.org>.

    it "should transliterate properly" do
      t("Это просто некий текст").should == "Eto prosto nekiy tekst"
      t("щ").should == "sch"
      t("стансы").should == "stansy"
      t("упущение").should == "upuschenie"
      t("ш").should == "sh"
      t("Ш").should == "SH"
      t("ц").should == "ts"
    end
    
    it "should properly transliterate mixed russian-english strings" do
      t("Это кусок строки русских букв v peremeshku s latinizey i амперсандом (pozor!) & something").should == 
        "Eto kusok stroki russkih bukv v peremeshku s latinizey i ampersandom (pozor!) & something"      
    end
    
    it "should properly transliterate mixed case chars in a string" do
      t("НЕВЕРОЯТНОЕ УПУЩЕНИЕ").should == "NEVEROYATNOE UPUSCHENIE"
      t("Невероятное Упущение").should == "Neveroyatnoe Upuschenie"
      t("Шерстяной Заяц").should == "Sherstyanoy Zayats"
      t("Н.П. Шерстяков").should == "N.P. Sherstyakov"
      t("ШАРОВАРЫ").should == "SHAROVARY"
    end

    it "should work for multi-char substrings" do
      t("38 воробьёв").should == "38 vorobiev"
      t("Вася Воробьёв").should == "Vasya Vorobiev"
      t("Алябьев").should == "Alyabiev"
      t("АЛЯБЬЕВ").should == "ALYABIEV"
    end
  end
end