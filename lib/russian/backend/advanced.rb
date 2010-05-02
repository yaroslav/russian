# -*- encoding: utf-8 -*- 

module I18n
  module Backend
    # "Продвинутый" бекэнд для I18n.
    # 
    # Наследует Simple бекэнд и полностью с ним совместим. Добаляет поддержку 
    # для отдельностоящих/контекстных названий дней недели и месяцев.
    # Также позволяет каждому языку использовать собственные правила плюрализации,
    # объявленные как Proc (<tt>lambda</tt>).
    # 
    #
    # Advanced I18n backend.
    #
    # Extends Simple backend. Allows usage of "standalone" keys
    # for DateTime localization and usage of user-defined Proc (lambda) pluralization
    # methods in translation tables.
    class Advanced < Simple
      LOCALIZE_ABBR_MONTH_NAMES_MATCH = /(%d|%e)(.*)(%b)/
      LOCALIZE_MONTH_NAMES_MATCH = /(%d|%e)(.*)(%B)/
      LOCALIZE_STANDALONE_ABBR_DAY_NAMES_MATCH = /^%a/
      LOCALIZE_STANDALONE_DAY_NAMES_MATCH = /^%A/
      
      # Acts the same as +strftime+, but returns a localized version of the 
      # formatted date string. Takes a key from the date/time formats 
      # translations as a format argument (<em>e.g.</em>, <tt>:short</tt> in <tt>:'date.formats'</tt>).
      #
      #
      # Метод отличается от <tt>localize</tt> в Simple бекэнде поддержкой 
      # отдельностоящих/контекстных названий дней недели и месяцев.
      #
      #
      # Note that it differs from <tt>localize</tt> in Simple< backend by checking for 
      # "standalone" month name/day name keys in translation and using them if available.
      #
      # <tt>options</tt> parameter added for i18n-0.3 compliance.
      def localize(locale, object, format = :default, options = nil)
        raise ArgumentError, "Object must be a Date, DateTime or Time object. #{object.inspect} given." unless object.respond_to?(:strftime)
        
        type = object.respond_to?(:sec) ? 'time' : 'date'
        # TODO only translate these if format is a String?
        formats = translate(locale, :"#{type}.formats")
        format = formats[format.to_sym] if formats && formats[format.to_sym]
        # TODO raise exception unless format found?
        format = format.to_s.dup

        # TODO only translate these if the format string is actually present
        # TODO check which format strings are present, then bulk translate then, then replace them

        if lookup(locale, :"date.standalone_abbr_day_names")
          format.gsub!(LOCALIZE_STANDALONE_ABBR_DAY_NAMES_MATCH, 
            translate(locale, :"date.standalone_abbr_day_names")[object.wday])
        end
        format.gsub!(/%a/, translate(locale, :"date.abbr_day_names")[object.wday])
        
        if lookup(locale, :"date.standalone_day_names")
          format.gsub!(LOCALIZE_STANDALONE_DAY_NAMES_MATCH, 
            translate(locale, :"date.standalone_day_names")[object.wday])
        end
        format.gsub!(/%A/, translate(locale, :"date.day_names")[object.wday])

        if lookup(locale, :"date.standalone_abbr_month_names")
          format.gsub!(LOCALIZE_ABBR_MONTH_NAMES_MATCH) do
            $1 + $2 + translate(locale, :"date.abbr_month_names")[object.mon]
          end
          format.gsub!(/%b/, translate(locale, :"date.standalone_abbr_month_names")[object.mon])
        else
          format.gsub!(/%b/, translate(locale, :"date.abbr_month_names")[object.mon])
        end

        if lookup(locale, :"date.standalone_month_names")
          format.gsub!(LOCALIZE_MONTH_NAMES_MATCH) do
            $1 + $2 + translate(locale, :"date.month_names")[object.mon]
          end
          format.gsub!(/%B/, translate(locale, :"date.standalone_month_names")[object.mon])
        else
          format.gsub!(/%B/, translate(locale, :"date.month_names")[object.mon])
        end

        format.gsub!(/%p/, translate(locale, :"time.#{object.hour < 12 ? :am : :pm}")) if object.respond_to? :hour
        object.strftime(format)
      end
      
      protected
        # Использует правила плюрализации из таблицы переводов для языка (если присутствуют),
        # иначе использует правило плюрализации по умолчанию (английский язык).
        # 
        # Пример задания правила в таблице переводов:
        #
        #   store_translations :'en', {
        #     :pluralize => lambda { |n| n == 1 ? :one : :other }
        #   }
        # 
        # Правило должно возвращать один из символов для таблицы переводов:
        #   :zero, :one, :two, :few, :many, :other
        #
        #
        # Picks a pluralization rule specified in translation tables for a language or
        # uses default pluralization rules.
        #
        # This is how pluralization rules are defined in translation tables, English
        # language for example:
        #
        #   store_translations :'en', {
        #     :pluralize => lambda { |n| n == 1 ? :one : :other }
        #   }
        #
        # Rule must return a symbol to use with pluralization, it must be one of:
        #   :zero, :one, :two, :few, :many, :other
        def pluralize(locale, entry, count)
          return entry unless entry.is_a?(Hash) and count

          key = :zero if count == 0 && entry.has_key?(:zero)
          locale_pluralize = lookup(locale, :pluralize)
          if locale_pluralize && locale_pluralize.respond_to?(:call)
            key ||= locale_pluralize.call(count)
          else
            key ||= default_pluralizer(count)
          end
          raise InvalidPluralizationData.new(entry, count) unless entry.has_key?(key)

          entry[key]
        end
        
        # Default pluralizer, used if pluralization rule is not defined in translations.
        #
        # Uses English pluralization rules -- it will pick the first translation if count is not equal to 1
        # and the second translation if it is equal to 1.
        def default_pluralizer(count)
          count == 1 ? :one : :other
        end
    end
  end
end
