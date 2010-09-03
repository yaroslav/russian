# -*- encoding: utf-8 -*- 

# Заменяет хелпер Rails <tt>select_month</tt> и метод <tt>translated_month_names</tt> 
# для поддержки функционала "отдельностоящих имен месяцев".
#
# Теперь можно использовать и полные, и сокращенные название месяцев в двух вариантах -- контекстном
# (по умолчанию) и отдельностоящем (если в текущем языке есть соответствующие переводы).
# Теперь хелперы поддерживают ключ <tt>:use_standalone_month_names</tt>, хелпер <tt>select_month</tt> 
# устанавливает его по умолчанию.
# Отдельностоящие имена месяцев также используютс когда указан ключ <tt>:discard_day</tt>.
#
#
# Replaces Rails <tt>select_month</tt> helper and <tt>translated_month_names</tt> private method to provide
# "standalone month names" feature. 
#
# It is now possible to use both abbreviated and full month names in two variants (if current locale provides them).
# All date helpers support <tt>:use_standalone_month_names</tt> key now, <tt>select_month</tt> helper sets 
# it to true by default.
# Standalone month names are also used when <tt>:discard_day</tt> key is provided.
if defined?(ActionView::Helpers::DateTimeSelector) && ActionView::Helpers::DateTimeSelector.private_instance_methods.map(&:to_sym).include?(:translated_month_names)
  module ActionView
    module Helpers
      module DateHelper
        # Returns a select tag with options for each of the months January through December with the current month
        # selected. The month names are presented as keys (what's shown to the user) and the month numbers (1-12) are
        # used as values (what's submitted to the server). It's also possible to use month numbers for the presentation
        # instead of names -- set the <tt>:use_month_numbers</tt> key in +options+ to true for this to happen. If you
        # want both numbers and names, set the <tt>:add_month_numbers</tt> key in +options+ to true. If you would prefer
        # to show month names as abbreviations, set the <tt>:use_short_month</tt> key in +options+ to true. If you want
        # to use your own month names, set the <tt>:use_month_names</tt> key in +options+ to an array of 12 month names. 
        # You can also choose if you want to use i18n standalone month names or default month names -- you can
        # force standalone month names usage by using <tt>:use_standalone_month_names</tt> key.
        # Override the field name using the <tt>:field_name</tt> option, 'month' by default.
        #
        #
        # Также поддерживается ключ <tt>:use_standalone_month_names</tt> для явного указания о необходимости
        # использования отдельностоящих имен месяцев, если текущий язык их поддерживает.
        #
        #
        # ==== Examples
        #   # Generates a select field for months that defaults to the current month that
        #   # will use keys like "January", "March".
        #   select_month(Date.today)
        #
        #   # Generates a select field for months that defaults to the current month that
        #   # is named "start" rather than "month"
        #   select_month(Date.today, :field_name => 'start')
        #
        #   # Generates a select field for months that defaults to the current month that
        #   # will use keys like "1", "3".
        #   select_month(Date.today, :use_month_numbers => true)
        #
        #   # Generates a select field for months that defaults to the current month that
        #   # will use keys like "1 - January", "3 - March".
        #   select_month(Date.today, :add_month_numbers => true)
        #
        #   # Generates a select field for months that defaults to the current month that
        #   # will use keys like "Jan", "Mar".
        #   select_month(Date.today, :use_short_month => true)
        #
        #   # Generates a select field for months that defaults to the current month that
        #   # will use keys like "Januar", "Marts."
        #   select_month(Date.today, :use_month_names => %w(Januar Februar Marts ...))
        #
        def select_month(date, options = {}, html_options = {})
          DateTimeSelector.new(date, options.merge(:use_standalone_month_names => true), html_options).select_month
        end
      end
      
      class DateTimeSelector #:nodoc:
        private
          # Returns translated month names
          #  => [nil, "January", "February", "March",
          #           "April", "May", "June", "July",
          #           "August", "September", "October",
          #           "November", "December"]
          #
          # If :use_short_month option is set
          #  => [nil, "Jan", "Feb", "Mar", "Apr", "May", "Jun",
          #           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
          #
          # Also looks up if <tt>:discard_day</tt> or <tt>:use_standalone_month_names</tt> option is set
          # and uses i18n standalone month names if so.
          #
          #
          # Также в зависимости от использования ключей <tt>:discard_day</tt> или <tt>:use_standalone_month_names</tt>
          # убеждается, есть ли соотвествующие переводы в текущем языке и использует "отдельностоящие" названия
          # месяцев по необходимости
          def translated_month_names
            begin
              if @options[:use_short_month]
                if (@options[:discard_day] || @options[:use_standalone_month_names]) && I18n.translate(:'date.standalone_abbr_month_names')
                  key = :'date.standalone_abbr_month_names'
                else
                  key = :'date.abbr_month_names'
                end
              else
                if (@options[:discard_day] || @options[:use_standalone_month_names]) && I18n.translate(:'date.standalone_month_names')
                  key = :'date.standalone_month_names'
                else
                  key = :'date.month_names'
                end
              end
              
              I18n.translate(key, :locale => @options[:locale])
            end
          end
          
      end
    end
  end
end # if defined?