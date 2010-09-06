# -*- encoding: utf-8 -*- 

if defined?(ActiveRecord::Error) # Rails 2.3.4+
  module ActiveRecord
    class Error
      protected
        if instance_methods.map(&:to_sym).include?(:default_options) # Rails 2.3.5+
          # Redefine the ActiveRecord::Error::generate_full_message method:
          #  Returns all the full error messages in an array. 'Base' messages are handled as usual.
          #  Non-base messages are prefixed with the attribute name as usual UNLESS they begin with '^'
          #  in which case the attribute name is omitted.
          #  E.g. validates_acceptance_of :accepted_terms, :message => '^Please accept the terms of service'
          #
          #
          # Переопределяет метод ActiveRecord::Error::generate_full_message. Сообщения об ошибках для атрибутов
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
          def generate_full_message(options = {})
            keys = [
              :"full_messages.#{@message}",
              :'full_messages.format',
              '%{attribute} %{message}'
            ]

            if self.message.is_a?(String) && self.message =~ /^\^/
              ActiveSupport::Deprecation.warn("Using '^' hack for ActiveRecord error messages has been deprecated. Please use errors.full_messages.format I18n key for formatting")

              options[:full_message] = self.message[1..-1]

              keys = [
                :"full_messages.#{@message}",
                '%{full_message}'
              ]
            else
              keys = [
                :"full_messages.#{@message}",
                :'full_messages.format',
                '%{attribute} %{message}'
              ]
            end

            options.merge!(:default => keys, :message => self.message)

            I18n.translate(keys.shift, options)
          end
        else # Rails 2.3.4
          # Redefine the ActiveRecord::Error::generate_full_message method:
          #  Returns all the full error messages in an array. 'Base' messages are handled as usual.
          #  Non-base messages are prefixed with the attribute name as usual UNLESS they begin with '^'
          #  in which case the attribute name is omitted.
          #  E.g. validates_acceptance_of :accepted_terms, :message => '^Please accept the terms of service'
          #
          #
          # Переопределяет метод ActiveRecord::Error::generate_full_message. Сообщения об ошибках для атрибутов
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
          def generate_full_message(message, options = {})
            options.reverse_merge! :message => self.message,
                                   :model => @base.class.human_name,
                                   :attribute => @base.class.human_attribute_name(attribute.to_s),
                                   :value => value
          
            key = :"full_messages.#{@message}"
            defaults = [:'full_messages.format', '%{attribute} %{message}']
          
            if options[:message].is_a?(String) && options[:message] =~ /^\^/
              ActiveSupport::Deprecation.warn("Using '^' hack for ActiveRecord error messages has been deprecated. Please use errors.full_messages.format I18n key for formatting")

              options[:full_message] = options[:message][1..-1]
              defaults = [:"full_messages.#{@message}.format", '%{full_message}']
            end
            
            I18n.t(key, options.merge(:default => defaults, :scope => [:activerecord, :errors]))
          end
        end
    end
  end

else # Rails 2.3.3-
  module ActiveRecord
    class Errors
      # DEPRECATED as of Rails 2.3.4
      #
      # The following is taken from custom_error_message plugin by David Easley
      # (http://rubyforge.org/projects/custom-err-msg/)
      #
      # Redefine the ActiveRecord::Errors::full_messages method:
      #  Returns all the full error messages in an array. 'Base' messages are handled as usual.
      #  Non-base messages are prefixed with the attribute name as usual UNLESS they begin with '^'
      #  in which case the attribute name is omitted.
      #  E.g. validates_acceptance_of :accepted_terms, :message => '^Please accept the terms of service'
      #
      #
      # Переопределяет метод ActiveRecord::Errors::full_messages. Сообщения об ошибках для атрибутов
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
      def full_messages
        full_messages = []

        @errors.each_key do |attr|
          @errors[attr].each do |msg|
            next if msg.nil?

            if attr == "base"
              full_messages << msg
            elsif msg =~ /^\^/
              full_messages << msg[1..-1]
            else
              full_messages << @base.class.human_attribute_name(attr) + " " + msg
            end
          end
        end

        return full_messages
      end
    end
  end
end
