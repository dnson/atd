module ATD
	module Commands
		class InitDataLoad
			def initialize(environment)
				@environment = environment
			end
			def start
				puts @environment.port
      end
      def run_idl_file
        require 'atd/flow/ridl'
        ATD::Flow::RIDL.new(@environment).perform
      end
    end
  end
end
