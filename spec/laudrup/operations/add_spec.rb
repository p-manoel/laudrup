RSpec.describe Laudrup::Operations::Add do
  describe 'failures' do
    context 'when the operation input type is invalid' do
      it 'returns a failure' do
        # Given
        invalid_operation_input = [nil, {}, 'a', 0].sample
  
        # When
        operation_result = described_class.call(
          operation_input: invalid_operation_input
        )

        # Then
        expect(operation_result).to have_attributes(
          failure?: true,
          type: :invalid_attributes
        )
      end
      
      it 'exposes an error' do
      # Given
      invalid_operation_input = [nil, {}, 'a', 0].sample
        
      # When
      operation_result = described_class.call(
        operation_input: invalid_operation_input
      )

      # Then
      expect(operation_result[:errors])
        .to be_a(::ActiveModel::Errors)
        .and include(:operation_input)
      end
    end

    context 'when the numbers of operation input are insufficient' do
      it 'returns a failure' do
        # Given
        operation_input_with_insufficient_arguments = [[1], ["1"], [1.0]].sample

        # When
        operation_result = described_class.call(
          operation_input: operation_input_with_insufficient_arguments
        )
       
        # Then
        expect(operation_result).to have_attributes(
          failure?: true,
          type: :insufficient_operation_arguments
        )
      end
      
      it 'exposes an error' do
        # Given
        operation_input_with_insufficient_arguments = [[1], ["1"], [1.0]].sample

        # When
        operation_result = described_class.call(
          operation_input: operation_input_with_insufficient_arguments
        )
       
        # Then
        expect(operation_result[:insufficient_operation_arguments]).to be(true)
      end
    end

    context 'when some of operation arguments are not numeric' do
      it 'returns a failure' do
        # Given
        operation_input_with_non_numeric_arguments = [[1, "a", 3],
                                                      ["1", 2, 3.0],
                                                      [1.0, 2, {}]].sample
        # When
        operation_result = described_class.call(
          operation_input: operation_input_with_non_numeric_arguments
        )
       
        # Then
        expect(operation_result).to have_attributes(
          failure?: true,
          type: :operation_arguments_must_be_numerics
        )
      end
      
      it 'exposes an error' do
        # Given
        operation_input_with_a_non_numeric_argument = [[1, "a", 3],
                                                      ["1", 2, 3.0],
                                                      [1.0, 2, {}]].sample
        # When
        operation_result = described_class.call(
          operation_input: operation_input_with_a_non_numeric_argument
        )
       
        # Then
        expect(operation_result[:operation_arguments_must_be_numerics]).to be(true)
      end
    end
  end

  describe 'success' do
    context 'when the arguments are valid' do
      it 'returns a success' do
        # Given
        valid_operation_input = [1, 2, 3]

        # When
        operation_result = described_class.call(
          operation_input: valid_operation_input
        )

        # Then
        expect(operation_result).to have_attributes(
          success?: true,
          type: :ok,
        )
      end

      it 'exposes the operation result and its details' do
        # Given
        valid_operation_input = [1, 2, 3]

        # When
        operation_result = described_class.call(
          operation_input: valid_operation_input
        )

        # Then
        expect(operation_result).to have_attributes(
          data: {
            operation: described_class,
            operation_input: valid_operation_input,
            operation_result: 6
          }
        )
      end
    end
  end
end