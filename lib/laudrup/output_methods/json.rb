# frozen_string_literal: true

require 'logger'

module Laudrup
  module OutputMethods
    class Json < ::Micro::Case
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
        operation_details_as_hash = { operation_arguments_with_operator => operation_result }

        current_jsonfile_content = File.read('operations.json')
        current_jsonfile_content_as_hash = if current_jsonfile_content == ''
                                             JSON.parse('[]')
                                           else
                                             JSON.parse(current_jsonfile_content)
                                           end

        new_content = current_jsonfile_content_as_hash << operation_details_as_hash

        File.open('operations.json', 'w') do |f|
          f.puts JSON.pretty_generate(new_content)
        end

        Success :writed_on_jsonfile, result: { operation_details: operation_details }
      end
    end
  end
end
