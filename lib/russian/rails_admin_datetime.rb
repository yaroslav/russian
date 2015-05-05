require 'rails_admin'
require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          class << self
            alias_method :normalize_without_russian, :normalize
            def normalize(date_string, format)
              unless I18n.locale == :en
                format.to_s.scan(/%[AaBbp]/) do |match|
                  case match
                  when '%B'
                    english = I18n.t('date.month_names', :locale => :en)[1..-1]
                    common_month_names = I18n.t('date.common_month_names')[1..-1]
                    common_month_names.each_with_index {|m, i| date_string = date_string.gsub(/#{m}/i, english[i]) }
                  when '%b'
                    english = I18n.t('date.abbr_month_names', :locale => :en)[1..-1]
                    common_abbr_month_names = I18n.t('date.common_abbr_month_names')[1..-1]
                    common_abbr_month_names.each_with_index {|m, i| date_string = date_string.gsub(/#{m}/i, english[i]) }
                  end
                end
              end
              normalize_without_russian(date_string, format)
            end
          end

          def formatted_date_value
            value = bindings[:object].new_record? && self.value.nil? && !self.default_value.nil? ? self.default_value : self.value
            value.nil? ? "" : (I18n.l(value, format: '%2d').strip + ' ' + I18n.l(value, format: '%B %Y').strip)
          end

          def value
            bindings[:object].send(name)
          end
        end
      end
    end
  end
end
