# frozen_string_literal: true

# I18n transliteration delegates to `Russian::Transliteration` (we're unable
# to use common I18n transliteration tables with Russian).
#
#
# Правило транслитерации для I18n использует `Russian::Transliteration`
# (использовать обычный механизм и таблицу транслитерации I18n с
# русским языком не получится).
{
  ru: {
    i18n: {
      transliterate: {
        rule: ->(str) { Russian.transliterate(str) }
      }
    }
  }
}
