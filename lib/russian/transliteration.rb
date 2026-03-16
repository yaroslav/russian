# frozen_string_literal: true

module Russian
  # Russian transliteration tables and helpers.
  #
  # Transliteration is heavily based on the
  # [rutils](https://github.com/julik/rutils) gem by
  # Julian "julik" Tarkhanov and contributors, then cleaned up and
  # adapted for this gem.
  #
  #
  # Таблицы и хелперы для русской транслитерации.
  #
  # Транслитерация во многом основана на gem
  # [rutils](https://github.com/julik/rutils) Юлика Тарханова и
  # соавторов, а затем упрощена и адаптирована для этого gem'а.
  #
  # @example
  #   Russian::Transliteration.transliterate("Юлия")
  #   # => "Yuliya"
  #
  #   Russian::Transliteration.transliterate("Н.П. Шерстяков")
  #   # => "N.P. Sherstyakov"
  module Transliteration
    module_function

    # @private
    LOWER_SINGLE = {
      "і" => "i", "ґ" => "g", "ё" => "yo", "№" => "#", "є" => "e",
      "ї" => "yi", "а" => "a", "б" => "b",
      "в" => "v", "г" => "g", "д" => "d", "е" => "e", "ж" => "zh",
      "з" => "z", "и" => "i", "й" => "y", "к" => "k", "л" => "l",
      "м" => "m", "н" => "n", "о" => "o", "п" => "p", "р" => "r",
      "с" => "s", "т" => "t", "у" => "u", "ф" => "f", "х" => "h",
      "ц" => "ts", "ч" => "ch", "ш" => "sh", "щ" => "sch", "ъ" => "'",
      "ы" => "y", "ь" => "", "э" => "e", "ю" => "yu", "я" => "ya"
    }.freeze
    # @private
    LOWER_MULTI = {
      "ье" => "ie",
      "ьё" => "ie"
    }.freeze

    # @private
    UPPER_SINGLE = {
      "Ґ" => "G", "Ё" => "YO", "Є" => "E", "Ї" => "YI", "І" => "I",
      "А" => "A", "Б" => "B", "В" => "V", "Г" => "G",
      "Д" => "D", "Е" => "E", "Ж" => "ZH", "З" => "Z", "И" => "I",
      "Й" => "Y", "К" => "K", "Л" => "L", "М" => "M", "Н" => "N",
      "О" => "O", "П" => "P", "Р" => "R", "С" => "S", "Т" => "T",
      "У" => "U", "Ф" => "F", "Х" => "H", "Ц" => "TS", "Ч" => "CH",
      "Ш" => "SH", "Щ" => "SCH", "Ъ" => "'", "Ы" => "Y", "Ь" => "",
      "Э" => "E", "Ю" => "YU", "Я" => "YA"
    }.freeze
    # @private
    UPPER_MULTI = {
      "ЬЕ" => "IE",
      "ЬЁ" => "IE"
    }.freeze

    # @private
    LOWER = LOWER_SINGLE.merge(LOWER_MULTI).freeze
    # @private
    UPPER = UPPER_SINGLE.merge(UPPER_MULTI).freeze
    # @private
    TITLE = UPPER.transform_values(&:capitalize).freeze
    # @private
    MULTI_KEYS = LOWER_MULTI.merge(UPPER_MULTI).keys.sort_by(&:length).reverse.freeze
    # @private
    TOKEN_RE = /#{Regexp.union(MULTI_KEYS).source}|./m

    # Transliterates a string containing Cyrillic characters.
    #
    # The method preserves non-Cyrillic characters and follows the historical
    # casing rules of the gem.
    #
    #
    # Транслитерирует строку, содержащую кириллические символы.
    #
    # Метод сохраняет некириллические символы и следует историческим правилам
    # gem'а для регистра.
    #
    # @param str [String] String to transliterate.
    #   Строка для транслитерации.
    # @return [String] Transliteration result.
    #   Результат транслитерации.
    #
    # @example
    #   Russian::Transliteration.transliterate("Привет, мир!")
    #   # => "Privet, mir!"
    def transliterate(str)
      tokens = str.scan(TOKEN_RE)

      tokens.each_with_index.map do |token, index|
        lower = LOWER[token]
        next lower if lower

        upper = UPPER[token]
        next TITLE[token] if upper && LOWER[tokens[index + 1]]
        next upper if upper

        token
      end.join
    end
  end
end
