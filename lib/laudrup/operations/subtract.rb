# frozen_string_literal: true

module Laudrup
  module Operations
    class Subtract < ::Micro::Case
      attribute :operation_input, validates: { kind: ::Array }

      def call!
        return Failure :insufficient_operation_arguments if operation_input.length < 2

        return Failure :operation_arguments_must_be_numerics unless operation_input.all?(Numeric)

        operation_result = operation_input.reduce(:-)

        Success result: { operation: Subtract,
                          operation_input: operation_input,
                          operation_result: operation_result }
      end
    end
  end
end
