require 'atd/flow/idl'

module ATD
	module Commands
		class IDL
			def initialize(environment)
				@environment = environment
			end
			def start
				puts @environment.port
      end
      def run_idl_file
        require 'atd/commands/iload'
        ATD::Flow::IDL.new(@environment).perform
      end
    end
  end
end
