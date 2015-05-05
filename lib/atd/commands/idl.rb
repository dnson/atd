module ATD
	module Commands
		class IDL

			def initialize(environment)
				@environment = environment
			end
			def start
				puts @environment.config
			end
			def run_idl_file
				system "bash", "-c", "iload --host=#{@environment.host} --listen=#{@environment.port} --username=#{@environment.username} --password=#{@environment.password} --database=#{@environment.database} -i #{@environment.file} --format=csv --table=#{@environment.table}  --delim=$'\t' --quote=$'\b'"
			end
		end
	end
end