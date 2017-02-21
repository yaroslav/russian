# -*- encoding: utf-8 -*- 

# Context-based month name and day name switching for Russian
#
# Названия месяцев и дней недели в зависимости от контекста ("1 декабря", но "Декабрь 1985")
{
  :ru => {
    :date => {
      :abbr_day_names => lambda { |key, options|
        if options[:format] && options[:format] =~ Russian::LOCALIZE_STANDALONE_ABBR_DAY_NAMES_MATCH
          :'date.common_abbr_day_names'
        else
          :'date.standalone_abbr_day_names'
        end
      },
      :day_names => lambda { |key, options|
        if options[:format] && options[:format] =~ Russian::LOCALIZE_STANDALONE_DAY_NAMES_MATCH
          :'date.standalone_day_names'
        else
          :'date.common_day_names'
        end
      },
      :abbr_month_names => lambda { |key, options|
        if options[:format] && options[:format] =~ Russian::LOCALIZE_ABBR_MONTH_NAMES_MATCH
          :'date.common_abbr_month_names'
        else
          :'date.standalone_abbr_month_names'
        end
      },
      :month_names => lambda { |key, options|
        if options[:format] && options[:format] =~ Russian::LOCALIZE_MONTH_NAMES_MATCH
          :'date.common_month_names'
        else
          :'date.standalone_month_names'
        end
      }
    }
  }
}
