# -*- encoding: utf-8 -*-

if defined?(ActiveModel::Errors)
  module ActiveModel
    class Errors
      # Redefine the ActiveModel::Errors.full_messages method:
      #  Returns all the full error messages in an array. 'Base' messages are handled as usual.
      #  Non-base messages are prefixed with the attribute name as usual UNLESS they begin with '^'
      #  in which case the attribute name is omitted.
      #  E.g. validates_acceptance_of :accepted_terms, :message => '^Please accept the terms of service'
      
      def full_message(attribute, message)
        return message if attribute == :base
        attr_name = attribute.to_s.tr('.', '_').humanize
        attr_name = @base.class.human_attribute_name(attribute, default: attr_name)
        
        if message =~ /^\^/
          message[1..-1]
        else
          I18n.t(:"errors.format", {
            default:  "%{attribute} %{message}",
            attribute: attr_name,
            message:   message
          })
        end
      end
      
      def to_hash(full_messages = false)
        if full_messages
          self.messages.each_with_object({}) do |(attribute, array), messages|
            messages[attribute] = array.map { |message| full_message(attribute, message) }
          end
        else
          self.messages.dup.map do |k, vs|
            m = vs.map do |v|
              if v =~ /^\^/
                v[1..-1]
              else
                v
              end
            end
            {k => m}
          end.reduce(:merge)
        end
      end
    end
  end
end
