require 'atd/base/use_case'
require 'atd/flow/base'

module ATD
  module Flow
    class IDL < Base
      include ATD::Base::UseCase

      def initialize(environment)
        @environment = environment
      end
      def perform
        require_all 'idl'
        ATD::Flow::IDLFlow::DataFromFileStep.new(@environment).run

      end
    end
  end
end

