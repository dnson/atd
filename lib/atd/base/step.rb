module ATD
  module Base
    class Step
      attr_reader :errors, :result

      def initialize
        @errors = []
        @result = []
      end

      def success?
        errors.none?
      end

      def run
        raise NotImplementedError
      end
    end
  end
end
