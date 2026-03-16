# frozen_string_literal: true

require "date"
require "time"

module Russian
  # Localized `strptime` helpers for Russian month and weekday names.
  #
  # The module normalizes Russian textual date/time tokens to the English
  # tokens expected by Ruby's native parsers, then delegates to
  # `Date.strptime`, `Time.strptime`, or `DateTime.strptime`.
  #
  #
  # Локализованные хелперы `strptime` для русских названий месяцев и дней
  # недели.
  #
  # Модуль нормализует русские текстовые токены даты и времени к английским
  # токенам, которые ожидают стандартные parser'ы Ruby, а затем делегирует
  # работу в `Date.strptime`, `Time.strptime` или `DateTime.strptime`.
  module Strptime
    module_function

    # Parses a localized Russian date string with `Date.strptime`.
    #
    #
    # Разбирает локализованную русскую строку даты через `Date.strptime`.
    #
    # @param string [String] Localized date string.
    #   Локализованная строка даты.
    # @param format [String] Optional `strptime` format string.
    #   Строка формата `strptime`.
    # @return [Date] Parsed date.
    #   Разобранная дата.
    def date_strptime(string, format = "%F")
      Date.strptime(normalize_input(string, format), format, Date::ITALY)
    end

    # Parses a localized Russian date/time string with `Time.strptime`.
    #
    #
    # Разбирает локализованную русскую строку даты и времени через
    # `Time.strptime`.
    #
    # @param string [String] Localized date/time string.
    #   Локализованная строка даты и времени.
    # @param format [String] `strptime` format string.
    #   Строка формата `strptime`.
    # @param now [Time] Optional base time passed to `Time.strptime`.
    #   Базовое значение времени, передаваемое в `Time.strptime`.
    # @return [Time] Parsed time.
    #   Разобранное время.
    def time_strptime(string, format, now = Time.now)
      Time.strptime(normalize_input(string, format), format, now)
    end

    # Parses a localized Russian date/time string with `DateTime.strptime`.
    #
    #
    # Разбирает локализованную русскую строку даты и времени через
    # `DateTime.strptime`.
    #
    # @param string [String] Localized date/time string.
    #   Локализованная строка даты и времени.
    # @param format [String] Optional `strptime` format string.
    #   Строка формата `strptime`.
    # @return [DateTime] Parsed datetime.
    #   Разобранный `DateTime`.
    def datetime_strptime(string, format = "%FT%T%z")
      DateTime.strptime(normalize_input(string, format), format, Date::ITALY)
    end

    # @private
    def normalize_input(string, format)
      return string unless string.is_a?(String) && format.is_a?(String)

      replacements = localized_replacements(format)
      return string if replacements.empty?

      token_regexp = Regexp.new(
        "(?<!\\p{L})(?:#{replacements.keys.sort_by(&:length).reverse.map do |token|
          Regexp.escape(token)
        end.join("|")})(?!\\p{L})",
        Regexp::IGNORECASE
      )

      string.gsub(token_regexp) { |token| replacements.fetch(token.downcase) }
    end

    # @private
    def localized_replacements(format)
      directives = directives_in(format)
      replacements = {}

      replacements.merge!(localized_tokens(month_names_key(format), Date::MONTHNAMES)) if directives.include?("B")

      if directives.include?("b")
        replacements.merge!(localized_tokens(abbr_month_names_key(format), Date::ABBR_MONTHNAMES))
      end

      replacements.merge!(localized_tokens(day_names_key(format), Date::DAYNAMES)) if directives.include?("A")

      replacements.merge!(localized_tokens(abbr_day_names_key(format), Date::ABBR_DAYNAMES)) if directives.include?("a")

      replacements
    end

    # @private
    def localized_tokens(key, english_names)
      localized_names = I18n.t(key, locale: Russian::LOCALE).compact
      english_names = english_names.compact

      localized_names.zip(english_names).each_with_object({}) do |(localized_name, english_name), replacements|
        replacements[localized_name.downcase] = english_name
      end
    end

    # @private
    def directives_in(format)
      directives = []
      index = 0

      while index < format.length
        if format[index] != "%"
          index += 1
          next
        end

        if format[index + 1] == "%"
          index += 2
          next
        end

        index += 1
        index += 1 while index < format.length && Russian::STRPTIME_DIRECTIVE_MODIFIERS.include?(format[index])
        index += 1 while index < format.length && format[index].match?(/\d/)

        index += 1 if index < format.length && %w[E O].include?(format[index])

        directives << format[index] if index < format.length
        index += 1
      end

      directives
    end

    # @private
    def month_names_key(format)
      Russian::LOCALIZE_MONTH_NAMES_MATCH.match?(format) ? :"date.common_month_names" : :"date.standalone_month_names"
    end

    # @private
    def abbr_month_names_key(format)
      Russian::LOCALIZE_ABBR_MONTH_NAMES_MATCH.match?(format) ? :"date.common_abbr_month_names" : :"date.standalone_abbr_month_names"
    end

    # @private
    def day_names_key(format)
      Russian::LOCALIZE_STANDALONE_DAY_NAMES_MATCH.match?(format) ? :"date.standalone_day_names" : :"date.common_day_names"
    end

    # @private
    def abbr_day_names_key(format)
      Russian::LOCALIZE_STANDALONE_ABBR_DAY_NAMES_MATCH.match?(format) ? :"date.common_abbr_day_names" : :"date.standalone_abbr_day_names"
    end
  end
end
