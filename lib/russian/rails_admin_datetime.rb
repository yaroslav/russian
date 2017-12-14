require 'rails_admin/support/datetime'

class RailsAdmin::Support::Datetime
  class << self
    alias_method :delocalize_without_russian, :delocalize
    def delocalize(date_string, format)
      ret = date_string
      if I18n.locale == :ru
        format.to_s.scan(/%[AaBbp]/) do |match|
          case match
          when '%B'
            english = I18n.t('date.month_names', :locale => :en)[1..-1]
            common_month_names = I18n.t('date.common_month_names')[1..-1]
            common_month_names.each_with_index {|m, i| ret = ret.gsub(/#{m}/i, english[i]) } unless ret.blank?
          when '%b'
            english = I18n.t('date.abbr_month_names', :locale => :en)[1..-1]
            common_abbr_month_names = I18n.t('date.common_abbr_month_names')[1..-1]
            common_abbr_month_names.each_with_index {|m, i| ret = ret.gsub(/#{m}/i, english[i]) } unless ret.blank?
          end
        end
      end
      ret = delocalize_without_russian(ret, format)
      ret
    end
  end
end

require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          register_instance_option :formatted_value do
            ret = if time = (value || default_value)
              opt = {format: strftime_format, standalone: true}
              Russian.force_standalone = true
              r = ::I18n.l(time, opt)
              Russian.force_standalone = false
              r
            else
              ''.html_safe
            end
            ret
          end
        end
      end
    end
  end
end
