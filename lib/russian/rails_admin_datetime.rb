require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          def parse_input(params)
            str = params[name]
            unless I18n.locale == :en
              strftime_format.to_s.scan(/%[AaBbp]/) do |match|
                case match
                when '%B'
                  english = I18n.t('date.month_names', :locale => :en)[1..-1]
                  common_month_names = I18n.t('date.common_month_names')[1..-1]
                  common_month_names.each_with_index {|m, i| str = str.gsub(/#{m}/i, english[i]) } unless str.blank?
                when '%b'
                  english = I18n.t('date.abbr_month_names', :locale => :en)[1..-1]
                  common_abbr_month_names = I18n.t('date.common_abbr_month_names')[1..-1]
                  common_abbr_month_names.each_with_index {|m, i| str = str.gsub(/#{m}/i, english[i]) } unless str.blank?
                end
              end
            end
            params[name] = parser.parse_string(str) if params[name]
          end

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
