# frozen_string_literal: true

module Russian
  # Gem version constants.
  #
  # The version is split into major, minor, and tiny components, plus a string
  # representation.
  #
  #
  # Константы версии gem'а.
  #
  # Версия разбита на major, minor и tiny-компоненты, а также на строковое
  # представление.
  #
  # @example
  #   Russian::VERSION::STRING
  #   # => "1.0.0"
  module VERSION
    MAJOR = 1
    MINOR = 0
    TINY = 0

    # Full version string.
    #
    # Полная строка версии.
    #
    # @return [String] Full version string.
    #   Полная строка версии.
    STRING = [MAJOR, MINOR, TINY].join(".")
  end
end
