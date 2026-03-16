# frozen_string_literal: true

# Russian language pluralization rules, taken from CLDR project,
# http://unicode.org/cldr/
#
#
# Правило плюрализации для русского языка, взято из CLDR,
# http://unicode.org/cldr/
#
#   one -> n mod 10 is 1 and n mod 100 is not 11;
#   few -> n mod 10 in 2..4 and n mod 100 not in 12..14;
#   many -> n mod 10 is 0 or n mod 10 in 5..9 or n mod 100 in 11..14;
#   other -> everything else
#
# Example:
#
#   :one  = 1, 21, 31, 41, 51, 61...
#   :few  = 2-4, 22-24, 32-34...
#   :many = 0, 5-20, 25-30, 35-40...
#   :other = 1.31, 2.31, 5.31...
from_2_to_4 = (2..4).to_a.freeze
from_5_to_9 = (5..9).to_a.freeze
from_11_to_14 = (11..14).to_a.freeze
from_12_to_14 = (12..14).to_a.freeze

{
  ru: {
    i18n: {
      plural: {
        rule: lambda do |n|
          return :other unless n.is_a?(Numeric)

          mod10 = n % 10
          mod100 = n % 100

          if mod10 == 1 && mod100 != 11
            :one
          elsif from_2_to_4.include?(mod10) && !from_12_to_14.include?(mod100)
            :few
          elsif mod10.zero? || from_5_to_9.include?(mod10) || from_11_to_14.include?(mod100)
            :many
          else
            :other
          end
        end
      }
    }
  }
}
