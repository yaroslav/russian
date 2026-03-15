# frozen_string_literal: true

module Russian
  # Rails date helper integration with support for standalone month names.
  #
  # The patch teaches Rails date helpers to distinguish between common
  # ("01 декабря") and standalone ("Декабрь") month names when the active
  # locale provides both forms.
  #
  # For Russian, `select_month` always uses standalone month names. Other month
  # rendering helpers switch to standalone names when `:discard_day` or
  # `:use_standalone_month_names` is set. If split translations are unavailable,
  # the implementation falls back to the standard Rails month-name keys.
  #
  #
  # Интеграция с Rails date helper'ами для поддержки отдельностоящих
  # названий месяцев.
  #
  # Патч учит Rails date helper'ы различать контекстные ("01 декабря") и
  # отдельностоящие ("Декабрь") формы названий месяцев, если активная локаль
  # предоставляет обе формы.
  #
  # Для русского языка `select_month` всегда использует отдельностоящие
  # названия месяцев. Остальные helper'ы, рендерящие месяцы, переключаются на
  # отдельностоящие формы, если указан `:discard_day` или
  # `:use_standalone_month_names`. Если раздельных переводов нет, реализация
  # откатывается к стандартным ключам Rails для названий месяцев.
  module ActionViewExt
    # Helper patches injected into Action View.
    #
    #
    # Патчи хелперов, внедряемые в Action View.
    module Helpers
      # @private
      MONTH_NAME_KEYS = {
        short: {
          common: :"date.common_abbr_month_names",
          standalone: :"date.standalone_abbr_month_names",
          fallback: :"date.abbr_month_names"
        },
        long: {
          common: :"date.common_month_names",
          standalone: :"date.standalone_month_names",
          fallback: :"date.month_names"
        }
      }.freeze

      # Patch for `ActionView::Helpers::DateHelper`.
      #
      #
      # Патч для `ActionView::Helpers::DateHelper`.
      module DateHelperPatch
        # Builds a `<select>` with month options and forces standalone month
        # names for Russian.
        #
        # The method keeps standard Rails month helper behavior and options,
        # but injects `use_standalone_month_names: true` before delegating to
        # Rails. This makes Russian month names render as standalone forms such
        # as `Декабрь` instead of contextual forms such as `декабря`.
        #
        #
        # Формирует `<select>` со списком месяцев и принудительно использует
        # отдельностоящие названия месяцев для русского языка.
        #
        # Метод сохраняет стандартное поведение и опции Rails month helper'а,
        # но перед делегированием в Rails добавляет
        # `use_standalone_month_names: true`. Благодаря этому для русского
        # языка рендерятся отдельностоящие формы вроде `Декабрь`, а не
        # контекстные формы вроде `декабря`.
        #
        # @param date [Date, Time, DateTime, Integer, nil] Selected month value.
        #   Выбранное значение месяца.
        # @param options [Hash] Rails helper options.
        #   Опции Rails-хелпера.
        # @option options [Boolean] :use_month_numbers Show month numbers instead of names.
        #   Показывать номера месяцев вместо названий.
        # @option options [Boolean] :add_month_numbers Prefix month names with numbers.
        #   Добавлять номер месяца перед названием.
        # @option options [Boolean] :use_short_month Use abbreviated month names.
        #   Использовать сокращенные названия месяцев.
        # @option options [Array<String>] :use_month_names Custom month names array.
        #   Пользовательский массив названий месяцев.
        # @option options [String, Symbol] :field_name Override the field name, `"month"` by default.
        #   Переопределить имя поля; по умолчанию используется `"month"`.
        # @option options [Boolean] :use_standalone_month_names Request standalone month names explicitly.
        #   Явно запросить отдельностоящие названия месяцев.
        # @param html_options [Hash] HTML options.
        #   HTML-опции.
        # @return [String] HTML for the select tag.
        #   HTML для select-тега.
        #
        # @example Default Russian output
        #   select_month(Date.new(2024, 12, 1))
        #   # => uses standalone month names for :ru
        #
        # @example Custom field name
        #   select_month(Date.new(2024, 12, 1), field_name: "start")
        #   # => overrides the generated field name
        #
        # @example Abbreviated standalone month names
        #   select_month(Date.new(2024, 12, 1), use_short_month: true)
        #   # => uses abbreviated standalone month names
        def select_month(date, options = {}, html_options = {})
          super(date, options.merge(use_standalone_month_names: true), html_options)
        end
      end

      # @private
      module DateTimeSelectorPatch
        private

        # Returns translated month names for the current selector options.
        #
        # The method chooses between common and standalone month-name
        # translations depending on `:discard_day`,
        # `:use_standalone_month_names`, and `:use_short_month`. If split
        # common/standalone translations are not defined for the current
        # locale, it falls back to the standard Rails month-name keys.
        #
        #
        # Возвращает переведенные названия месяцев для текущих
        # опций selector'а.
        #
        # Метод выбирает между контекстными и отдельностоящими переводами
        # названий месяцев в зависимости от `:discard_day`,
        # `:use_standalone_month_names` и `:use_short_month`. Если для текущей
        # локали не определены раздельные контекстные и отдельностоящие
        # переводы, метод откатывается к стандартным ключам Rails.
        #
        # @return [Array<String, nil>] Month names array with `nil` at index `0`.
        #   Массив названий месяцев с `nil` на позиции `0`.
        def translated_month_names
          I18n.translate(translated_month_names_key, locale: month_names_locale)
        end

        def translated_month_names_key
          month_name_keys = MONTH_NAME_KEYS.fetch(@options[:use_short_month] ? :short : :long)
          return month_name_keys[:fallback] unless I18n.exists?(month_name_keys[:common], month_names_locale)

          standalone_month_names? ? month_name_keys[:standalone] : month_name_keys[:common]
        end

        def standalone_month_names?
          @options[:discard_day] || @options[:use_standalone_month_names]
        end

        def month_names_locale
          @options[:locale] || I18n.locale
        end
      end
    end
  end
end
