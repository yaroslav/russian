# frozen_string_literal: true

module Russian
  # Extensions for ActiveModel integration.
  #
  #
  # Расширения для интеграции с ActiveModel.
  module ActiveModelExt
    # Patch for `ActiveModel::Error.full_message`.
    # Validation messages prefixed with `^` suppress the humanized
    # attribute name in the resulting full message.
    #
    #
    # Патч для `ActiveModel::Error.full_message`.
    # Сообщения валидации с префиксом `^` подавляют humanized-имя
    # атрибута в итоговом полном сообщении.
    module ErrorPatch
      # Builds a full validation message and optionally suppresses the
      # attribute name when the message starts with `^`.
      #
      #
      # Строит полное сообщение валидации и при необходимости подавляет имя
      # атрибута, если сообщение начинается с `^`.
      #
      # @param attribute [String, Symbol] Attribute name.
      #   Имя атрибута.
      # @param message [#to_s] Validation message.
      #   Сообщение валидации.
      # @param base [Object] Model instance.
      #   Экземпляр модели.
      # @return [String] Full validation message.
      #   Полное сообщение валидации.
      #
      # @example
      #   ActiveModel::Error.full_message(:agreement, "^Нужно согласиться с соглашением", record)
      #   # => "Нужно согласиться с соглашением"
      def full_message(attribute, message, base)
        return super unless suppress_attribute_name?(attribute, message)

        message.to_s.delete_prefix("^")
      end

      private

      # @private
      def suppress_attribute_name?(attribute, message)
        attribute.to_s != "base" && message.to_s.start_with?("^")
      end
    end
  end
end
