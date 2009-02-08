# -*- encoding: utf-8 -*- 

module ActiveSupport
  module Inflector
    # Replaces special characters in a string so that it may be used as part of a 'pretty' URL.
    # Transliterates all russian characters in string first, then passes it to ActiveSupport Inflector.
    #
    # Заменяет все спецсимволы в строке так, что результат может использоваться как часть "красивого" URL.
    # От стандартного ActiveSupport Inflector отличается тем, что сначала производится транслитерация
    # букв русского алфавита.
    #
    # ==== Examples
    #
    # class Person
    #   def to_param
    #     "#{id}-#{name.parameterize}"
    #   end
    # end
    #
    # @person = Person.find(1)
    # # => #<Person id: 1, name: "Дональд Кнут">
    #
    # <%= link_to(@person.name, person_path %>
    # # => <a href="/person/1-donald-knut">Дональд Кнут</a>
    def parameterize_with_russian(string, sep = '-')
      parameterize_without_russian(Russian::transliterate(string), sep)
    end
    alias_method :parameterize_without_russian, :parameterize
    alias_method :parameterize, :parameterize_with_russian
  end
end
