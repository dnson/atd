require 'atd/flow/base'

module ATD
  module Flow
    class RIDL < Base

      def initialize(environment)
        @environment = environment
        @show_log = environment.show_log
      end
      def run
        require_all 'idl'
        base = ATD::Flow::IDL
       # base::SanitizeStep.new(@environment).perform
      #  base::DataFromFileStep.new(@environment).perform
        base::LoadCountryStep.new(@environment).perform
      end
    end
  end
end

