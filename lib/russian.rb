# -*- encoding: utf-8 -*- 

if RUBY_VERSION < "1.9"
  $KCODE = 'u'
end

$:.push File.join(File.dirname(__FILE__), 'russian')
require 'transliteration'

# I18n require
unless defined?(I18n)
  $:.push File.join(File.dirname(__FILE__), 'vendor', 'i18n', 'lib')
  require 'i18n'
end
# Advanced backend
require 'backend/advanced'

# Rails hacks
require 'active_record_ext/custom_error_message' if defined?(ActiveRecord)
if defined?(ActionView::Helpers)
  require 'action_view_ext/helpers/date_helper' 
end
require 'active_support_ext/parameterize' if defined?(ActiveSupport::Inflector)

module Russian
  extend self
  
  module VERSION
    MAJOR = 0
    MINOR = 2
    TINY  = 7

    STRING = [MAJOR, MINOR, TINY].join('.')
  end
  
  # Russian locale
  LOCALE = :'ru'

  # Russian locale
  def locale
    LOCALE
  end
  
  # Returns custom backend class for usage with Russian library
  # 
  # See I18n::Backend
  def i18n_backend_class
    I18n::Backend::Advanced
  end
  
  # Init Russian i18n: set custom backend, set default locale to Russian locale, load all translations
  # shipped with library.
  def init_i18n
    I18n.backend = Russian.i18n_backend_class.new
    I18n.default_locale = LOCALE
    I18n.load_path.unshift(*locale_files)
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
    localize(object, { :format => format })
  end
  
  # Simple pluralization proxy
  #
  # Usage: 
  #   Russian.pluralize(1, "вещь", "вещи", "вещей")
  #   Russian.pluralize(3.14, "вещь", "вещи", "вещей", "вещи")
  def pluralize(n, *variants)
    raise ArgumentError, "Must have a Numeric as a first parameter" unless n.is_a?(Numeric)
    raise ArgumentError, "Must have at least 3 variants for pluralization" if variants.size < 3
    raise ArgumentError, "Must have at least 4 variants for pluralization" if (variants.size < 4 && n != n.round)
    variants_hash = pluralization_variants_to_hash(*variants)
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
    # Returns all locale files shipped with library
    def locale_files
      Dir[File.join(File.dirname(__FILE__), "russian", "locale", "**/*")]
    end
    
    # Converts an array of pluralization variants to a Hash that can be used
    # with I18n pluralization.
    def pluralization_variants_to_hash(*variants)
      {
        :one => variants[0],
        :few => variants[1],
        :many => variants[2],
        :other => variants[3]
      }
    end
end

Russian.init_i18n
