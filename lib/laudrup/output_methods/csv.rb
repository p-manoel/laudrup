# frozen_string_literal: true

require 'csv'

module Laudrup
  module OutputMethods
    class Csv < ::Micro::Case
      attribute :operation, validates: { kind: Operations.class }
      attribute :operation_input, validates: { kind: ::Array }
      attribute :operation_result, validates: { kind: ::Numeric }

      OPERATORS = {
        Operations::Add => '+',
        Operations::Subtract => '-',
        Operations::Multiply => '*',
        Operations::Divide => '/'
      }.freeze

      def call!
        operator = OPERATORS.fetch(operation)

        operation_arguments_with_operator = operation_input.join(" #{operator} ")

        operation_details = "#{operation_arguments_with_operator} = #{operation_result}"
        operation_details_as_array = [operation_arguments_with_operator, operation_result]

        current_csvfile_content = CSV.read('operations.csv').nil? ? [] : CSV.read('operations.csv')

        new_content = current_csvfile_content << operation_details_as_array

        CSV.open('operations.csv', 'wb') do |csv|
          new_content.each do |operation_detail|
            csv << operation_detail
          end
        end

        Success :writed_on_csvfile, result: { operation_details: operation_details }
      end
    end
  end
end
