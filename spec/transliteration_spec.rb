# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Russian do
  describe "transliteration" do
    def transliterate(str)
      described_class.transliterate(str)
    end

    %i[transliterate translit].each do |method|
      it "#{method} delegates to Russian::Transliteration" do
        str = double("string")

        expect(Russian::Transliteration).to receive(:transliterate).with(str)

        described_class.public_send(method, str)
      end
    end

    it "transliterates basic Cyrillic strings" do
      {
        "Это просто некий текст" => "Eto prosto nekiy tekst",
        "щ" => "sch",
        "стансы" => "stansy",
        "упущение" => "upuschenie",
        "ш" => "sh",
        "Ш" => "SH",
        "ц" => "ts"
      }.each do |source, expected|
        expect(transliterate(source)).to eq(expected)
      end
    end

    it "transliterates mixed russian-english strings" do
      expect(transliterate("Это кусок строки русских букв v peremeshku s latinizey i амперсандом (pozor!) & something"))
        .to eq("Eto kusok stroki russkih bukv v peremeshku s latinizey i ampersandom (pozor!) & something")
    end

    it "transliterates mixed-case strings" do
      {
        "НЕВЕРОЯТНОЕ УПУЩЕНИЕ" => "NEVEROYATNOE UPUSCHENIE",
        "Невероятное Упущение" => "Neveroyatnoe Upuschenie",
        "Шерстяной Заяц" => "Sherstyanoy Zayats",
        "Н.П. Шерстяков" => "N.P. Sherstyakov",
        "ШАРОВАРЫ" => "SHAROVARY"
      }.each do |source, expected|
        expect(transliterate(source)).to eq(expected)
      end
    end

    it "works for multi-character substrings" do
      {
        "38 воробьёв" => "38 vorobiev",
        "Вася Воробьёв" => "Vasya Vorobiev",
        "Алябьев" => "Alyabiev",
        "АЛЯБЬЕВ" => "ALYABIEV"
      }.each do |source, expected|
        expect(transliterate(source)).to eq(expected)
      end
    end

    it "preserves newlines" do
      expect(transliterate("Привет\nмир")).to eq("Privet\nmir")
    end
  end
end
