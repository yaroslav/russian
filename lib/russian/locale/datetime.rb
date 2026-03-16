# frozen_string_literal: true

# Context-based month name and day name switching for Russian
#
#
# Названия месяцев и дней недели в зависимости от контекста
# ("01 декабря", но "Декабрь 1985")
{
  ru: {
    date: {
      abbr_day_names: lambda do |_value = nil, **options|
        format = options[:format]

        if format && Russian::LOCALIZE_STANDALONE_ABBR_DAY_NAMES_MATCH.match?(format)
          :"date.common_abbr_day_names"
        else
          :"date.standalone_abbr_day_names"
        end
      end,
      day_names: lambda do |_value = nil, **options|
        format = options[:format]

        if format && Russian::LOCALIZE_STANDALONE_DAY_NAMES_MATCH.match?(format)
          :"date.standalone_day_names"
        else
          :"date.common_day_names"
        end
      end,
      abbr_month_names: lambda do |_value = nil, **options|
        format = options[:format]

        if format && Russian::LOCALIZE_ABBR_MONTH_NAMES_MATCH.match?(format)
          :"date.common_abbr_month_names"
        else
          :"date.standalone_abbr_month_names"
        end
      end,
      month_names: lambda do |_value = nil, **options|
        format = options[:format]

        if format && Russian::LOCALIZE_MONTH_NAMES_MATCH.match?(format)
          :"date.common_month_names"
        else
          :"date.standalone_month_names"
        end
      end
    }
  }
}
