# -*- encoding: utf-8 -*-

module Russian
  # Russian transliteration
  #
  # Транслитерация для букв русского алфавита
  module Transliteration
    extend self

    # Transliteration heavily based on rutils gem by Julian "julik" Tarkhanov and Co.
    # <http://rutils.rubyforge.org/>
    # Cleaned up and optimized.

    LOWER_SINGLE = {
      "і"=>"i","ґ"=>"g","ё"=>"yo","№"=>"#","є"=>"e",
      "ї"=>"yi","а"=>"a","б"=>"b",
      "в"=>"v","г"=>"g","д"=>"d","е"=>"e","ж"=>"zh",
      "з"=>"z","и"=>"i","й"=>"y","к"=>"k","л"=>"l",
      "м"=>"m","н"=>"n","о"=>"o","п"=>"p","р"=>"r",
      "с"=>"s","т"=>"t","у"=>"u","ф"=>"f","х"=>"h",
      "ц"=>"ts","ч"=>"ch","ш"=>"sh","щ"=>"sch","ъ"=>"'",
      "ы"=>"y","ь"=>"","э"=>"e","ю"=>"yu","я"=>"ya",
    }
    LOWER_MULTI = {
      "ье"=>"ie",
      "ьё"=>"ie",
    }

    UPPER_SINGLE = {
      "Ґ"=>"G","Ё"=>"YO","Є"=>"E","Ї"=>"YI","І"=>"I",
      "А"=>"A","Б"=>"B","В"=>"V","Г"=>"G",
      "Д"=>"D","Е"=>"E","Ж"=>"ZH","З"=>"Z","И"=>"I",
      "Й"=>"Y","К"=>"K","Л"=>"L","М"=>"M","Н"=>"N",
      "О"=>"O","П"=>"P","Р"=>"R","С"=>"S","Т"=>"T",
      "У"=>"U","Ф"=>"F","Х"=>"H","Ц"=>"TS","Ч"=>"CH",
      "Ш"=>"SH","Щ"=>"SCH","Ъ"=>"'","Ы"=>"Y","Ь"=>"",
      "Э"=>"E","Ю"=>"YU","Я"=>"YA",
    }
    UPPER_MULTI = {
      "ЬЕ"=>"IE",
      "ЬЁ"=>"IE",
    }

    LOWER = (LOWER_SINGLE.merge(LOWER_MULTI)).freeze
    UPPER = (UPPER_SINGLE.merge(UPPER_MULTI)).freeze
    MULTI_KEYS = (LOWER_MULTI.merge(UPPER_MULTI)).keys.sort_by {|s| s.length}.reverse.freeze
    SCAN_REGEX = %r{#{MULTI_KEYS.join '|'}|\w|.}.freeze

    # Transliterate a string with russian characters
    #
    # Возвращает строку, в которой все буквы русского алфавита заменены на похожую по звучанию латиницу
    def transliterate(str)
      chars = str.scan(SCAN_REGEX)

      result = ''

      chars.each_with_index do |char, index|
        result << ( LOWER[char] || ( ( upper = UPPER[char] ) ? LOWER[chars[index+1]] ? upper.capitalize : upper : char ) )
      end

      result
    end
  end
end
