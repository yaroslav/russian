# frozen_string_literal: true

require "date"
require "russian"

abort "rails unexpectedly loaded" if defined?(Rails)
abort "wrong locale" unless Russian.locale == :ru
abort "translate failed" unless Russian.t(:"date.formats.default") == "%d.%m.%Y"
abort "legacy translate failed" unless Russian.t(:"date.formats.default", {}) == "%d.%m.%Y"
abort "localize failed" unless Russian.l(Date.new(1985, 12, 1), format: :long) == "01 декабря 1985"
abort "legacy localize failed" unless Russian.l(Date.new(1985, 12, 1), {format: :long}) == "01 декабря 1985"
abort "strftime failed" unless Russian.strftime(Date.new(1985, 12, 1), :long) == "01 декабря 1985"
abort "date_strptime failed" unless Russian.date_strptime("01 декабря 1985", "%d %B %Y") == Date.new(1985, 12, 1)
abort "pluralization failed" unless Russian.p(2, "one", "few", "many") == "few"
abort "transliteration failed" unless Russian.translit("Привет") == "Privet"
abort "i18n transliteration failed" unless I18n.transliterate("Привет", locale: :ru) == "Privet"

begin
  require "rails"
rescue LoadError
  puts "rails missing as expected"
else
  abort "rails unexpectedly available"
end

puts "ok"
