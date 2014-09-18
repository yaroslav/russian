# frozen_string_literal: true

require "i18n"

require_relative "russian/russian_rails"
require_relative "russian/transliteration"
require_relative "russian/version"

# Russian language support for Ruby: I18n helpers and Rails integration.
#
# The module wraps common gem `I18n` operations, adds its own helpers,
# and installs Rails-specific patches when Rails is detected.
#
# Don't forget to check `README`!
#
#
# Поддержка русского языка для Ruby: библиотеки I18n и интеграция с Rails.
#
# Модуль оборачивает типичные операции gem'а `I18n`, добавляет свои,
# и устанавливает Rails-специфичные патчи, если обнаружен Rails.
#
# Не забудьте прочитать `README`!
#
# @example
#   require "russian"
#   Russian.t(:"date.formats.default")
#   Russian.l(Date.new(1985, 12, 1), format: :long)
#   Russian.translit("Привет")
module Russian
  # Locale used by the gem.
  #
  #
  # Локаль, которую использует gem.
  #
  # @return [Symbol] Russian locale identifier.
  #   Идентификатор русской локали.
  LOCALE = :ru

  # @private
  LOCALIZE_ABBR_MONTH_NAMES_MATCH = /(%[-_0^#:]*(\d+)*[EO]?d|%[-_0^#:]*(\d+)*[EO]?e)(.*)(%b)/
  # @private
  LOCALIZE_MONTH_NAMES_MATCH = /(%[-_0^#:]*(\d+)*[EO]?d|%[-_0^#:]*(\d+)*[EO]?e)(.*)(%B)/
  # @private
  LOCALIZE_STANDALONE_ABBR_DAY_NAMES_MATCH = /^%a/
  # @private
  LOCALIZE_STANDALONE_DAY_NAMES_MATCH = /^%A/

  class << self
    # Returns the locale used by the gem.
    #
    #
    # Возвращает локаль, которую использует gem.
    #
    # @return [Symbol] Russian locale identifier.
    #   Идентификатор русской локали.
    #
    # @example
    #   Russian.locale
    #   # => :ru
    def locale
      LOCALE
    end

    # Installs Russian locale files into `I18n` and reloads the I18n backend.
    #
    # The method is safe to call repeatedly. It prepends this gem's locale
    # files to `I18n.load_path`, enables pluralization and transliteration
    # backends, and then calls `I18n.reload!`.
    #
    #
    # Подключает файлы русской локали к `I18n` и перезагружает backend I18n.
    #
    # Метод безопасно вызывать повторно. Он добавляет locale-файлы gem'а в
    # начало `I18n.load_path`, включает backend'ы pluralization и
    # transliteration, а затем вызывает `I18n.reload!`.
    #
    # @return [void]
    #
    # @example
    #   I18n.load_path.clear
    #   Russian.init_i18n
    #   I18n.t(:"date.month_names", locale: :ru)
    def init_i18n
      backend = I18n::Backend::Simple

      backend.include(I18n::Backend::Pluralization)
      backend.include(I18n::Backend::Transliterator)

      I18n.load_path = locale_files + (I18n.load_path - locale_files)
      I18n.reload!
    end

    # Translates a key using the Russian locale by default.
    #
    # Both the legacy positional hash and modern keyword arguments are
    # supported.
    #
    #
    # Переводит ключ, по умолчанию используя русскую локаль.
    #
    # Поддерживаются и устаревший positional hash, и современные
    # keyword-аргументы.
    #
    # @param key [String, Symbol] Translation key.
    #   Ключ перевода.
    # @param options [Hash, nil] Legacy positional I18n options hash.
    #   Устаревший positional hash с опциями I18n.
    # @param kwargs [Hash] Keyword I18n options.
    #   Keyword-опции I18n.
    # @return [Object] Translation result returned by `I18n`.
    #   Результат перевода, возвращаемый `I18n`.
    # @raise [ArgumentError] if `options` is not a hash.
    #   Если `options` не является hash'ем.
    #
    # @example
    #   Russian.translate(:"date.formats.default")
    #   Russian.translate(:"date.formats.default", scope: :foo)
    #   Russian.translate(:"date.formats.default", {scope: :foo})
    def translate(key, options = nil, **kwargs)
      I18n.translate(key, **normalize_i18n_options(options, kwargs, locale: LOCALE))
    end
    alias_method :t, :translate

    # @!method t(key, options = nil, **kwargs)
    #   Alias for {.translate}.
    #
    #
    #   Псевдоним для {.translate}.
    #
    #   @see .translate

    # Localizes an object using the Russian locale by default.
    #
    # Both the legacy positional hash and modern keyword arguments are
    # supported.
    #
    #
    # Локализует объект, по умолчанию используя русскую локаль.
    #
    # Поддерживаются и устаревший positional hash, и современные
    # keyword-аргументы.
    #
    # @param object [Object] Localizable object, usually `Date`, `Time`, or `DateTime`.
    #   Локализуемый объект, обычно `Date`, `Time` или `DateTime`.
    # @param options [Hash, nil] Legacy positional I18n options hash.
    #   Устаревший positional hash с опциями I18n.
    # @param kwargs [Hash] Keyword I18n options.
    #   Keyword-опции I18n.
    # @return [String] Localized string.
    #   Локализованная строка.
    # @raise [ArgumentError] if `options` is not a hash.
    #   Если `options` не является hash'ем.
    #
    # @example
    #   Russian.localize(Date.new(1985, 12, 1), format: :long)
    #   Russian.localize(Date.new(1985, 12, 1), {format: :long})
    def localize(object, options = nil, **kwargs)
      I18n.localize(object, **normalize_i18n_options(options, kwargs, locale: LOCALE))
    end
    alias_method :l, :localize

    # @!method l(object, options = nil, **kwargs)
    #   Alias for {.localize}.
    #
    #
    #   Псевдоним для {.localize}.
    #
    #   @see .localize

    # Localizes an object using a `strftime`-style format identifier.
    #
    # `Russian.strftime(time, :long)` and
    # `Russian.strftime(time, format: :long)` are both supported.
    #
    #
    # Локализует объект, используя идентификатор формата в стиле `strftime`.
    #
    # Поддерживаются форматы `Russian.strftime(time, :long)` и
    # `Russian.strftime(time, format: :long)`.
    #
    # @param object [Object] Localizable object.
    #   Локализуемый объект.
    # @param format [Symbol, Hash] Format name or legacy options hash.
    #   Имя формата или устаревший hash с опциями.
    # @param kwargs [Hash] Keyword I18n options.
    #   Keyword-опции I18n.
    # @return [String] Localized string.
    #   Локализованная строка.
    # @raise [ArgumentError] if a legacy options argument is not a hash.
    #   Если устаревший аргумент с опциями не является hash'ем.
    #
    # @example
    #   Russian.strftime(Time.new(2008, 9, 1, 11, 12, 43, "+03:00"), :long)
    #   Russian.strftime(Time.new(2008, 9, 1, 11, 12, 43, "+03:00"), format: :long)
    def strftime(object, format = :default, **kwargs)
      options =
        if format.is_a?(Hash)
          normalize_i18n_options(format, kwargs)
        else
          normalize_i18n_options({format: format}, kwargs)
        end

      localize(object, **options)
    end

    # Returns the correct Russian plural form for a numeric value.
    #
    # For integers, three variants are required: `one`, `few`, and `many`.
    # For non-integer numbers, a fourth `other` variant is also required.
    #
    #
    # Возвращает правильную русскую форму множественного числа для
    # числового значения.
    #
    # Для целых чисел нужны три варианта: `one`, `few` и `many`.
    # Для дробных чисел дополнительно нужен четвертый вариант `other`.
    #
    # @param n [Numeric] Number used for pluralization.
    #   Число для выбора формы.
    # @param variants [Array<Object>] Pluralization variants in the order `one`, `few`, `many`, `other`.
    #   Варианты в порядке `one`, `few`, `many`, `other`.
    # @return [Object] Selected pluralization variant.
    #   Выбранный вариант склонения.
    # @raise [ArgumentError] if `n` is not numeric or required variants are missing.
    #   Если `n` не число или не переданы нужные варианты.
    #
    # @example
    #   Russian.pluralize(1, "вещь", "вещи", "вещей")
    #   # => "вещь"
    #   Russian.pluralize(3.14, "вещь", "вещи", "вещей", "вещи")
    #   # => "вещи"
    def pluralize(n, *variants)
      raise ArgumentError, "Must have a Numeric as a first parameter" unless n.is_a?(Numeric)
      raise ArgumentError, "Must have at least 3 variants for pluralization" if variants.size < 3
      raise ArgumentError, "Must have at least 4 variants for pluralization" if variants.size < 4 && n != n.round

      variants_hash = pluralization_variants_to_hash(*variants)
      I18n.backend.send(:pluralize, LOCALE, variants_hash, n)
    end
    alias_method :p, :pluralize

    # @!method p(n, *variants)
    #   Alias for {.pluralize}.
    #
    #
    #   Псевдоним для {.pluralize}.
    #
    #   @see .pluralize

    # Transliterates a string from Cyrillic to Latin characters.
    #
    # The method delegates to {Transliteration.transliterate} and preserves the
    # historical casing behavior of the gem.
    #
    #
    # Транслитерирует строку из кириллицы в латиницу.
    #
    # Метод делегирует работу в {Transliteration.transliterate} и сохраняет
    # историческое поведение gem'а по работе с регистром.
    #
    # @param str [String] String to transliterate.
    #   Строка для транслитерации.
    # @return [String] Transliteration result.
    #   Результат транслитерации.
    #
    # @example
    #   Russian.transliterate("Юлия")
    #   # => "Yuliya"
    def transliterate(str)
      Transliteration.transliterate(str)
    end
    alias_method :translit, :transliterate

    # @!method translit(str)
    #   Alias for {.transliterate}.
    #
    #
    #   Псевдоним для {.transliterate}.
    #
    #   @see .transliterate

    private

    # @private
    def locale_files
      Dir[File.join(__dir__, "russian", "locale", "**", "*")].select { |path| File.file?(path) }.sort
    end

    # @private
    def pluralization_variants_to_hash(*variants)
      {
        one: variants[0],
        few: variants[1],
        many: variants[2],
        other: variants[3]
      }
    end

    # @private
    def normalize_i18n_options(options = nil, kwargs = {}, defaults = {})
      legacy_options = options || {}

      raise ArgumentError, "Options must be provided as a Hash or keyword arguments" unless legacy_options.is_a?(Hash)

      defaults.merge(legacy_options).merge(kwargs)
    end
  end
end

Russian.init_i18n
