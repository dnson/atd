module ATD
	module Commands
		class IDL

			def initialize(environment)
				@environment = environment
			end
			def start
				puts @environment.port
			end
		end
	end
end