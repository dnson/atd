require "atd/logger"
module ATD
  module Base
    class Step
      attr_reader :errors, :result

      def initialize
        @errors = []
        @result = []
        @log=[]
      end

      def success?
        errors.none?
      end
      def class_name
        self.class.name
      end
      def log(msg, show=false)
        Lotus::Logger.new(class_name).info(msg) if show
      end
      def run
        raise NotImplementedError
      end
    end
  end
end
