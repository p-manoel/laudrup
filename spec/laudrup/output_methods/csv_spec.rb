# frozen_string_literal: true

require 'csv'

RSpec.describe Laudrup::OutputMethods::Csv do
  describe 'failures' do
    context 'with invalid operation argument' do
      it 'returns a failure' do
        # Given
        invalid_operation_argument = [nil, 'a', 3].sample

        # When
        console_result = described_class.call(
          operation: invalid_operation_argument,
          operation_input: [1, 2, 3],
          operation_result: 6
        )

        # Then
        expect(console_result).to have_attributes(
          failure?: true,
          type: :invalid_attributes
        )
      end

      it 'exposes an error' do
        # Given
        invalid_operation_argument = [nil, 'a', 3].sample

        # When
        console_result = described_class.call(
          operation: invalid_operation_argument,
          operation_input: [1, 2, 3],
          operation_result: 6
        )

        # Then
        expect(console_result[:errors])
          .to be_a(::ActiveModel::Errors)
          .and include(:operation)
      end
    end

    context 'with invalid operation_input argument' do
      it 'returns a failure' do
        # Given
        random_operation = [
          Laudrup::Operations::Add,
          Laudrup::Operations::Subtract,
          Laudrup::Operations::Multiply,
          Laudrup::Operations::Divide
        ].sample
        invalid_operation_input = [nil, 'a', 3].sample

        # When
        console_result = described_class.call(
          operation: random_operation,
          operation_input: invalid_operation_input,
          operation_result: 6
        )

        # Then
        expect(console_result).to have_attributes(
          failure?: true,
          type: :invalid_attributes
        )
      end

      it 'exposes an error' do
        # Given
        random_operation = [
          Laudrup::Operations::Add,
          Laudrup::Operations::Subtract,
          Laudrup::Operations::Multiply,
          Laudrup::Operations::Divide
        ].sample
        invalid_operation_input = [nil, 'a', 3].sample

        # When
        console_result = described_class.call(
          operation: random_operation,
          operation_input: invalid_operation_input,
          operation_result: 6
        )

        # Then
        expect(console_result[:errors])
          .to be_a(::ActiveModel::Errors)
          .and include(:operation_input)
      end
    end

    context 'with invalid operation_result argument' do
      it 'returns a failure' do
        # Given
        random_operation = [
          Laudrup::Operations::Add,
          Laudrup::Operations::Subtract,
          Laudrup::Operations::Multiply,
          Laudrup::Operations::Divide
        ].sample
        invalid_operation_result = ['1', nil, :b].sample

        # When
        console_result = described_class.call(
          operation: random_operation,
          operation_input: [1, 2, 3],
          operation_result: invalid_operation_result
        )

        # Then
        expect(console_result).to have_attributes(
          failure?: true,
          type: :invalid_attributes
        )
      end

      it 'exposes an error' do
        # Given
        random_operation = [
          Laudrup::Operations::Add,
          Laudrup::Operations::Subtract,
          Laudrup::Operations::Multiply,
          Laudrup::Operations::Divide
        ].sample
        invalid_operation_result = ['1', nil, :b].sample

        # When
        console_result = described_class.call(
          operation: random_operation,
          operation_input: [1, 2, 3],
          operation_result: invalid_operation_result
        )

        # Then
        expect(console_result[:errors])
          .to be_a(::ActiveModel::Errors)
          .and include(:operation_result)
      end
    end
  end

  describe 'success' do
    context 'with valid arguments' do
      it 'returns a success' do
        # Given
        random_valid_operation = [
          Laudrup::Operations::Add,
          Laudrup::Operations::Subtract,
          Laudrup::Operations::Multiply,
          Laudrup::Operations::Divide
        ].sample
        valid_operation_input = [[1, 2, 3], [1, '2', 3], [1, 2, 3.0]].sample
        valid_operation_result = 6

        # When
        log_result = described_class.call(
          operation: random_valid_operation,
          operation_input: valid_operation_input,
          operation_result: valid_operation_result
        )

        # Then
        expect(log_result).to have_attributes(
          success?: true,
          type: :writed_on_csvfile
        )
      end

      it 'writes the operation details on log file' do
        # Given
        random_valid_operation = [
          Laudrup::Operations::Add,
          Laudrup::Operations::Subtract,
          Laudrup::Operations::Multiply,
          Laudrup::Operations::Divide
        ].sample
        valid_operation_input = [[1, 2, 3], [1, '2', 3], [1, 2, 3.0]].sample
        valid_operation_result = 6

        operators = {
          Laudrup::Operations::Add => '+',
          Laudrup::Operations::Subtract => '-',
          Laudrup::Operations::Multiply => '*',
          Laudrup::Operations::Divide => '/'
        }.freeze

        # When
        described_class.call(
          operation: random_valid_operation,
          operation_input: valid_operation_input,
          operation_result: valid_operation_result
        )

        operation_arguments_with_operator = valid_operation_input.join(" #{operators.fetch(random_valid_operation)} ")

        last_line_of_csvfile = CSV.read('operations.csv').last

        # Then
        expect(last_line_of_csvfile).to eq([operation_arguments_with_operator, valid_operation_result.to_s])
      end
    end
  end
end
