require "atd/logger"
require "atd/base/use_case"
require "atd/base/itransaction"
module ATD
  module Base
    class Step
      attr_reader :errors, :result
      include ATD::Base::UseCase
      include ATD::Base::ITransaction
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
        return true
      end
      def run
        raise NotImplementedError
      end
      def quit
        return true
      end
      def perform
        log("Entrance",@show_log)
        prepare
        if prepare && run && quit
          commit
        else
          rollback
        end
        log("Quit",@show_log)
      end


    end
  end
end
