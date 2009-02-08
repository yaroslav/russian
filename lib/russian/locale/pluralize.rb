# -*- encoding: utf-8 -*- 

{
  :'ru' => {
    :pluralize => lambda { |n| 
      # Правило плюрализации для русского языка, взято из CLDR, http://unicode.org/cldr/
      #
      #
      # Russian language pluralization rules, taken from CLDR project, http://unicode.org/cldr/
      #
      #   one -> n mod 10 is 1 and n mod 100 is not 11;
      #   few -> n mod 10 in 2..4 and n mod 100 not in 12..14;
      #   many -> n mod 10 is 0 or n mod 10 in 5..9 or n mod 100 in 11..14;
      #   other -> everything else
      #
      # Пример
      #
      #   :one	= 1, 21, 31, 41, 51, 61...
      #   :few	= 2-4, 22-24, 32-34...
      #   :many = 0, 5-20, 25-30, 35-40...
      #   :other = 1.31, 2.31, 5.31...
      modulo10 = n.modulo(10)
      modulo100 = n.modulo(100)
      
      if modulo10 == 1 && modulo100 != 11
        :one
      elsif (modulo10 == 2 || modulo10 == 3 || modulo10 == 4) && !(modulo100 == 12 || modulo100 == 13 || modulo100 == 14)
        :few
      elsif modulo10 == 0 || (modulo10 == 5 || modulo10 == 6 || modulo10 == 7 || modulo10 == 8 || modulo10 == 9) || (modulo100 == 11 || modulo100 == 12 || modulo100 == 13 || modulo100 == 14)
        :many
      else
        :other
      end
    }
  }
}