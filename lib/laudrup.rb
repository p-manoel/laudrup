# frozen_string_literal: true

require 'active_model'
require 'u-case/with_activemodel_validation'

require_relative 'laudrup/version'

require_relative 'laudrup/operations/add'
require_relative 'laudrup/operations/subtract'
require_relative 'laudrup/operations/multiply'
require_relative 'laudrup/operations/divide'

require_relative 'laudrup/output_methods/console'

module Laudrup
  class Error < StandardError; end
  # Your code goes here...
end
