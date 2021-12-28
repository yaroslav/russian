# -*- encoding: utf-8 -*- 

if defined?(ActiveModel::Errors)
  module ActiveModel
    class Errors
      # Redefine the ActiveModel::Errors.full_messages method:
      #  Returns all the full error messages in an array. 'Base' messages are handled as usual.
      #  Non-base messages are prefixed with the attribute name as usual UNLESS they begin with '^'
      #  in which case the attribute name is omitted.
      #  E.g. validates_acceptance_of :accepted_terms, :message => '^Please accept the terms of service'
      #
      # Переопределяет метод ActiveModel::Errors.full_messages. Сообщения об ошибках для атрибутов
      # теперь не имеют префикса с названием атрибута если в сообщении об ошибке первым символом указан "^".
      #
      # Так, например,
      # 
      #   validates_acceptance_of :accepted_terms, :message => 'нужно принять соглашение'
      # 
      # даст сообщение
      # 
      #   Accepted terms нужно принять соглашение
      # 
      # однако,
      # 
      #   validates_acceptance_of :accepted_terms, :message => '^Нужно принять соглашение'
      # 
      # даст сообщение
      # 
      #   Нужно принять соглашение
      #
      #
      # Returns all the full error messages in an array.
      #
      #   class Company
      #     validates_presence_of :name, :address, :email
      #     validates_length_of :name, :in => 5..30
      #   end
      #
      #   company = Company.create(:address => '123 First St.')
      #   company.errors.full_messages # =>
      #     ["Name is too short (minimum is 5 characters)", "Name can't be blank", "Address can't be blank"]
      def full_messages
        full_messages = []

        each do |attribute, messages|
          messages = Array.wrap(messages)
          next if messages.empty?

          if attribute == :base
            messages.each {|m| full_messages << m }
          else
            attr_name = attribute.to_s.gsub('.', '_').humanize
            attr_name = @base.class.human_attribute_name(attribute, :default => attr_name)
            options = { :attribute => attr_name, :default => "%{attribute} %{message}" }

            messages.each do |m|
              if m =~ /^\^/
                full_messages << m[1..-1]
              else
                full_messages << I18n.t(:"errors.format", **options.merge(:message => m))
              end
            end
          end
        end

        full_messages
      end
    end
  end
end # if defined?
