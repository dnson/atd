require "atd/logger"
require "atd/base/use_case"
module ATD
  module Base
    class Step
      attr_reader :errors, :result
      include ATD::Base::UseCase
      def initialize
        @errors = []
        @result = []
        @log=[]
        @show_log = false
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
      def prepare
        log("Entrance",@show_log)
      end
      def before_run
      end
      def run
        raise NotImplementedError
      end
      def after_run
      end
      def quit
        log("Quit",@show_log)
      end
      def perform
        prepare
        before_run
        run
        after_run
        quit
      end


    end
  end
end
