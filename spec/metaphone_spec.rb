# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/spec_helper'

describe Russian do
  describe "metaphone" do
    def m(str)
      Russian::metaphone(str)
    end

    it "'metaphone' method should perform metaphone generation code" do
      str = mock(:str)
      Russian::Metaphone.should_receive(:generate).with(str)
      Russian.send(:metaphone, str)
    end

    it "should generate proper metaphone" do
      m("").should == ""
      m("ih").should == "IH"
      m("Это просто некий текст").should == "Т ПРСТ НК ТКСТ"
      m("сочный").should == "ШН"
      m(" 2эта, \"3В21'").should == "Т Ф"
      m("иван-и-марья").should == "ФН МР"
      m("много букв").should == m("мнока букафф")
      m("небольшие опечатки и албанский").should == m("нипалшые опчатги олпансгие")
      m("ранний рассвет").should == m("раненное росифатой")
      m("китайский ресторан").should == m("кытаски ристаран")
      m("макдональдс").should == m("магдоналтс")
      m("поцанчик").should == m("патсанчег")
      m("напиться").should == m("напицца")
      m("сейчас").should == m("щаз")
      m("эта").should == m("этот")
    end

    it "should generate proper metaphone for mixed russian-english strings" do
      m("Это кусок строки русских букв v peremeshku s latinizey i амперсандом (pozor!) & something").should ==
        "Т КСК СТРК РСКХ ПКФ F PRMXHK S LTNS I МПРСНТМ PSR SMZNG"
    end
  end
end
