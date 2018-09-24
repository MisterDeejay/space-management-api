module Exceptions
  class SpacesCountExceeded < StandardError
    def initialize
      super("Space creation failed: Spaces count cannot exceed max")
    end
  end

  module QueryFinderError
    class OperationInvalid < StandardError
      def initialize
        super("Query failed: Comparison operator does not exist")
      end
    end
  end

  module CostCalculatorError
    class DateInvalid < StandardError
    end
  end
end
