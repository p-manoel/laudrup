module Laudrup
  module OutputMethods
    class Console < ::Micro::Case
      attribute :operation, validates: { kind: Operations.class }
      attribute :operation_input, validates: { kind: ::Array }
      attribute :operation_result, validates: { kind: ::Numeric }

      OPERATORS = {
        Operations::Add => '+',
        Operations::Subtract => '-',
        Operations::Multiply => '*',
        Operations::Divide => '/'
      }

      def call!
        operator = OPERATORS.fetch(operation)

        operation_arguments_with_operator = operation_input.join(" #{operator} ")

        operation_details = "#{operation_arguments_with_operator} = #{operation_result}"
        
        puts operation_details

        Success :printed, result: { operation_details: operation_details } 
      end
    end
  end
end