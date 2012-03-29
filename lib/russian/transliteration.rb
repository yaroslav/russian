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
      "»"=>"\"","«" => "\"","“"=>"\"","”" => "\"",
    }
    LOWER_MULTI = {
      "ье"=>"ie",
      "ьё"=>"ie",
      "сх"=>"skh",
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
      "СХ"=>"SKH",
    }

    REVERSE_LOWER_SINGLE = {
      "a"=>"а","b"=>"б","c"=>"с","d"=>"д",
      "e"=>"е","f"=>"ф","g"=>"г","h"=>"х",
      "i"=>"и","j"=>"й","k"=>"к","l"=>"л",
      "m"=>"м","n"=>"н","o"=>"о","p"=>"п",
      "q"=>"к","r"=>"р","s"=>"с","t"=>"т",
      "u"=>"у","v"=>"в","w"=>"у","x"=>"кс",
      "y"=>"ы","z"=>"з",
    }
    REVERSE_LOWER_MULTI = {
      "sch"=>"щ","skh"=>"сх",
      "aya"=>"ая","yaya"=>"яя","oyа"=>"оя","uyа"=>"уя","yyа"=>"ыя","eyа"=>"ея",
      "aye"=>"ае","oye"=>"ое","uye"=>"уе","yye"=>"ые","eye"=>"ее",
      "oye"=>"ое","oyo"=>"оё",
      "ayu"=>"аю","uyu"=>"ую","oyu"=>"ою","uyu"=>"ую","eyu"=>"ею",
      "yu"=>"ю","ya"=>"я","yo"=>"ё",
      "ju"=>"ю","ja"=>"я","jo"=>"ё",
      "yi"=>"ї","ji"=>"ї",
      "ay"=>"ай","yay"=>"яй","oy"=>"ой","yoy"=>"ёй","uy"=>"уй","yuy"=>"юй","yy"=>"ый","iy"=>"ий","ey"=>"ей",
      "ay"=>"ай","yay"=>"яй","oy"=>"ой","yoy"=>"ёй","uy"=>"уй","yuy"=>"юй","yy"=>"ый","iy"=>"ий","ey"=>"ей",
      "ch"=>"ч","zh"=>"ж","sh"=>"ш","ts"=>"ц",
    }

    REVERSE_UPPER_SINGLE = {
      "A"=>"А","B"=>"Б","C"=>"С","D"=>"Д",
      "E"=>"Е","F"=>"Ф","G"=>"Г","H"=>"Х",
      "I"=>"И","J"=>"Й","K"=>"К","L"=>"Л",
      "M"=>"М","N"=>"Н","O"=>"О","P"=>"П",
      "Q"=>"К","R"=>"Р","S"=>"С","T"=>"Т",
      "U"=>"У","V"=>"В","W"=>"У","X"=>"КС",
      "Y"=>"Ы","Z"=>"З","'"=>"Ъ",
    }
    REVERSE_UPPER_MULTI = {
      "SCH"=>"Щ","SKH"=>"СХ",
      "AYA"=>"АЯ","YAYA"=>"ЯЯ","OYА"=>"ОЯ","UYА"=>"УЯ","YYА"=>"ЫЯ","EYА"=>"ЕЯ",
      "AYE"=>"АЕ","OYE"=>"ОЕ","UYE"=>"УЕ","YYE"=>"ЫЕ","EYE"=>"ЕЕ",
      "OYE"=>"ОЕ","OYO"=>"ОЁ",
      "AYU"=>"АЮ","UYU"=>"УЮ","OYU"=>"ОЮ","UYU"=>"УЮ","EYU"=>"ЕЮ",
      "YU"=>"Ю","YA"=>"Я","YO"=>"Ё",
      "JU"=>"Ю","JA"=>"Я","JO"=>"Ё",
      "YI"=>"Ї","JI"=>"Ї",
      "AY"=>"АЙ","YAY"=>"ЯЙ","OY"=>"ОЙ","YOY"=>"ЁЙ","UY"=>"УЙ","YUY"=>"ЮЙ","YY"=>"ЫЙ","IY"=>"ИЙ","EY"=>"ЕЙ",
      "AY"=>"АЙ","YAY"=>"ЯЙ","OY"=>"ОЙ","YOY"=>"ЁЙ","UY"=>"УЙ","YUY"=>"ЮЙ","YY"=>"ЫЙ","IY"=>"ИЙ","EY"=>"ЕЙ",
      "CH"=>"Ч","ZH"=>"Ж","SH"=>"Ш","TS"=>"Ц",
    }

    LOWER = (LOWER_SINGLE.merge(LOWER_MULTI)).freeze
    UPPER = (UPPER_SINGLE.merge(UPPER_MULTI)).freeze
    MULTI_KEYS = (LOWER_MULTI.merge(UPPER_MULTI)).keys.sort_by {|s| s.length}.reverse.freeze
    MULTI_KEYS_PATTERN = MULTI_KEYS.join('|').freeze

    REVERSE_LOWER = (REVERSE_LOWER_SINGLE.merge(REVERSE_LOWER_MULTI)).freeze
    REVERSE_UPPER = (REVERSE_UPPER_SINGLE.merge(REVERSE_UPPER_MULTI)).freeze
    REVERSE_MULTI_KEYS = (REVERSE_LOWER_MULTI.merge(REVERSE_UPPER_MULTI)).keys.sort_by {|s| s.length}.reverse.freeze
    REVERSE_MULTI_KEYS_PATTERN = REVERSE_MULTI_KEYS.join('|').freeze

    # Transliterate a string with russian characters
    #
    # Возвращает строку, в которой все буквы русского алфавита заменены на похожую по звучанию латиницу
    def transliterate(str)
      convert(str, UPPER, LOWER, MULTI_KEYS_PATTERN)
    end

    # De-transliterate a latin string into cyrillic characters
    #
    # Возвращает строку, в которой все буквы латинского алфавита заменены на похожие по звучанию из кириллицы
    def detransliterate(str)
      convert(str, REVERSE_UPPER, REVERSE_LOWER, REVERSE_MULTI_KEYS_PATTERN)
    end

    def convert(str, upper, lower, multi_pattern)
      chars = str.scan(%r{#{multi_pattern}|\w|.})

      result = ""

      chars.each_with_index do |char, index|
        result << \
        if upper.has_key?(char) && lower.has_key?(chars[index+1])
          # combined case
          upper[char].downcase.capitalize
        elsif upper.has_key?(char)
          upper[char]
        elsif lower.has_key?(char)
          lower[char]
        else
          char
        end
      end

      result
    end

    LAYOUT_RUS_UPPER = 'ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ№"'
    LAYOUT_ENG_UPPER = 'QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>~#@'

    LAYOUT_RUS_LOWER = 'йцукенгшщзхъфывапролджэячсмитьбюё'
    LAYOUT_ENG_LOWER = "qwertyuiop[]asdfghjkl;'zxcvbnm,.`"

    LAYOUT_RUS = (LAYOUT_RUS_LOWER + LAYOUT_RUS_UPPER).freeze
    LAYOUT_ENG = (LAYOUT_ENG_LOWER + LAYOUT_ENG_UPPER).freeze

    def layout_rus(str)
      str.to_s.tr(LAYOUT_ENG, LAYOUT_RUS)
    end

    def layout_eng(str)
      str.to_s.tr(LAYOUT_RUS, LAYOUT_ENG)
    end
  end
end
