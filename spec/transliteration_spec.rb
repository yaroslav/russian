# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/spec_helper'

describe Russian do
  describe "transliteration" do
    def t(str)
      Russian::transliterate(str)
    end

    %w(transliterate translit).each do |method|
      it "'#{method}' method should perform transliteration" do
        str = double(:str)
        expect(Russian::Transliteration).to receive(:transliterate).with(str)
        Russian.send(method, str)
      end
    end

    # These tests are from rutils, <http://rutils.rubyforge.org>.

    it "should transliterate properly" do
      expect(t("Это просто некий текст")).to eq("Eto prosto nekiy tekst")
      expect(t("щ")).to eq("sch")
      expect(t("стансы")).to eq("stansy")
      expect(t("упущение")).to eq("upuschenie")
      expect(t("ш")).to eq("sh")
      expect(t("Ш")).to eq("SH")
      expect(t("ц")).to eq("ts")
    end

    it "should properly transliterate mixed russian-english strings" do
      expect(t("Это кусок строки русских букв v peremeshku s latinizey i амперсандом (pozor!) & something")).to eq(
        "Eto kusok stroki russkih bukv v peremeshku s latinizey i ampersandom (pozor!) & something"
      )
    end

    it "should properly transliterate mixed case chars in a string" do
      expect(t("НЕВЕРОЯТНОЕ УПУЩЕНИЕ")).to eq("NEVEROYATNOE UPUSCHENIE")
      expect(t("Невероятное Упущение")).to eq("Neveroyatnoe Upuschenie")
      expect(t("Шерстяной Заяц")).to eq("Sherstyanoy Zayats")
      expect(t("Н.П. Шерстяков")).to eq("N.P. Sherstyakov")
      expect(t("ШАРОВАРЫ")).to eq("SHAROVARY")
    end

    it "should work for multi-char substrings" do
      expect(t("38 воробьёв")).to eq("38 vorobiev")
      expect(t("Вася Воробьёв")).to eq("Vasya Vorobiev")
      expect(t("Алябьев")).to eq("Alyabiev")
      expect(t("АЛЯБЬЕВ")).to eq("ALYABIEV")
    end
  end
end
