require 'atd/flow/base'

module ATD
  module Flow
    class RIDL < Base

      def initialize(environment)
        @environment = environment
      end
      def run
        require_all 'idl'
        ATD::Flow::IDL::DataFromFileStep.new(@environment).run
      end
    end
  end
end

