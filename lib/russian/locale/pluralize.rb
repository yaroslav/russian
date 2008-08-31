{
  :'ru-RU' => {
    :pluralize => lambda { |n| 
      # Russian language pluralization rules, taken from CLDR project, http://unicode.org/cldr/
      #
      # one -> n mod 10 is 1 and n mod 100 is not 11;
      # few -> n mod 10 in 2..4 and n mod 100 not in 12..14;
      # many -> n mod 10 is 0 or n mod 10 in 5..9 or n mod 100 in 11..14;
      # other -> everything else
      if n.modulo(10) == 1 && n.modulo(100) != 11
        :one
      elsif (n.modulo(10) >=2 && n.modulo(10) <= 4) && (n.modulo(100) >=12 && n.modulo(100) <= 14)
        :few
      elsif n.modulo(10) == 0 || (n.modulo(10) >=5 && n.modulo(10) <= 9) || 
        (n.modulo(100) >= 11 && n.modulo(100) <= 14)
        :many
      else
        :other
      end
    }
  }
}