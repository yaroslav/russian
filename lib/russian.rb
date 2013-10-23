# coding: utf-8 

$KCODE = 'u' if RUBY_VERSION < "1.9"

require 'i18n'

$:.push File.join(File.dirname(__FILE__), 'russian')
require 'russian_rails'

if RUBY_ENGINE == "jruby"
  require 'unicode_utils/upcase'
else
  require 'unicode'
end

module Russian
  extend self

  autoload :Transliteration, 'transliteration'

  # Russian locale
  LOCALE = :'ru'

  # Russian locale
  def locale
    LOCALE
  end

  # Regexp machers for context-based russian month names and day names translation
  LOCALIZE_ABBR_MONTH_NAMES_MATCH = /(%[-_0^#:]*(\d+)*[EO]?d|%[-_0^#:]*(\d+)*[EO]?e)(.*)(%b)/
  LOCALIZE_MONTH_NAMES_MATCH = /(%[-_0^#:]*(\d+)*[EO]?d|%[-_0^#:]*(\d+)*[EO]?e)(.*)(%B)/
  LOCALIZE_STANDALONE_ABBR_DAY_NAMES_MATCH = /^%a/
  LOCALIZE_STANDALONE_DAY_NAMES_MATCH = /^%A/

  # Init Russian i18n: load all translations shipped with library.
  def init_i18n
    I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
    I18n::Backend::Simple.send(:include, I18n::Backend::Transliterator)

    I18n.load_path.unshift(*locale_files)

    I18n.reload!
  end

  # See I18n::translate
  def translate(key, options = {})
    I18n.translate(key, options.merge({ :locale => LOCALE }))
  end
  alias :t :translate

  # See I18n::localize
  def localize(object, options = {})
    I18n.localize(object, options.merge({ :locale => LOCALE }))
  end
  alias :l :localize

  # strftime() proxy with Russian localization
  def strftime(object, format = :default)
    localize(object, { :format => check_strftime_format(object, format) })
  end

  # Simple pluralization proxy
  #
  # Usage:
  #   Russian.pluralize(1, "вещь", "вещи", "вещей")
  #   Russian.pluralize(3.14, "вещь", "вещи", "вещей", "вещи")
  #   Russina.pluralize(5, "Произошла %n ошибка", "Произошло %n ошибки", "Произошло %n ошибок")
  def pluralize(n, *variants)
    raise ArgumentError, "Must have a Numeric as a first parameter" unless n.is_a?(Numeric)
    raise ArgumentError, "Must have at least 3 variants for pluralization" if variants.size < 3
    raise ArgumentError, "Must have at least 4 variants for pluralization" if (variants.size < 4 && n != n.round)
    variants_hash = pluralization_variants_to_hash(n, *variants)
    I18n.backend.send(:pluralize, LOCALE, variants_hash, n)
  end
  alias :p :pluralize

  # Transliteration for russian language
  #
  # Usage:
  #  Russian.translit("рубин")
  #  Russian.transliterate("рубин")
  def transliterate(str)
    Russian::Transliteration.transliterate(str)
  end
  alias :translit :transliterate

  protected
    
    def check_strftime_format(object, format)
      %w(A a B b).each do |key|
        if format =~ /%\^#{key}/ 
          if RUBY_ENGINE == "jruby"
            format = format.gsub("%^#{key}", UnicodeUtils.upcase(localize(object, { :format => "%#{key}" } )))
          else
            format = format.gsub("%^#{key}", Unicode::upcase(localize(object, { :format => "%#{key}" } )))
          end
        end
      end

      format
    end

    # Returns all locale files shipped with library
    def locale_files
      Dir[File.join(File.dirname(__FILE__), "russian", "locale", "**/*")]
    end

    # Converts an array of pluralization variants to a Hash that can be used
    # with I18n pluralization.
    def pluralization_variants_to_hash(n, *variants)
      variants.map!{ |variant| variant.gsub '%n', n.to_s }
      {
        :one => variants[0],
        :few => variants[1],
        :many => variants[2],
        :other => variants[3]
      }
    end
end

Russian.init_i18n
