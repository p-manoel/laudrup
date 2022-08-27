RSpec.describe Laudrup::OutputMethods::Console do
  describe 'failures' do
    context 'with invalid operation argument' do
      it 'returns a failure' do
        # Given
        invalid_operation_argument = [nil, "a", 3].sample

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
        invalid_operation_argument = [nil, "a", 3].sample

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
        invalid_operation_input = [nil, "a", 3].sample

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
        invalid_operation_input = [nil, "a", 3].sample

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
        invalid_operation_result = ["1", nil, :b].sample

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
        invalid_operation_result = ["1", nil, :b].sample

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
        console_result = described_class.call(
          operation: random_valid_operation,
          operation_input: valid_operation_input,
          operation_result: valid_operation_result
        )
  
        # Then
        expect(console_result).to have_attributes(
          success?: true,
          type: :printed
        )
      end

      it 'prints the operation details on console' do
        # Given
        random_valid_operation = [
          Laudrup::Operations::Add,
          Laudrup::Operations::Subtract,
          Laudrup::Operations::Multiply,
          Laudrup::Operations::Divide
        ].sample
        valid_operation_input = [[1, 2, 3], [1, '2', 3], [1, 2, 3.0]].sample
        valid_operation_result = 6

        OPERATORS = {
          Laudrup::Operations::Add => '+',
          Laudrup::Operations::Subtract => '-',
          Laudrup::Operations::Multiply => '*',
          Laudrup::Operations::Divide => '/'
        }
  
        # When
        console_result = described_class.call(
          operation: random_valid_operation,
          operation_input: valid_operation_input,
          operation_result: valid_operation_result
        )
        
        operation_arguments_with_operator = valid_operation_input.join(" #{OPERATORS.fetch(random_valid_operation)} ")
        expected_operation_details = "#{operation_arguments_with_operator} = #{valid_operation_result}"

        # Then
        expect(console_result).to have_attributes(
          data: {
            operation_details: expected_operation_details
          }
        )
      end
    end
  end
end