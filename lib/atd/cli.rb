require 'thor'
require 'atd/environment'
require 'atd/version'
module ATD

	class Cli < Thor


		desc 'version', 'print atd version'
		def version
			puts "v#{ATD::VERSION}"
		end
		
		desc 'test', 'test cli'
		def test
			ATD::Environment.new.root
		end
		
		desc 'run_idl', 'run initial data load for MSSS'
		method_option :host,      aliases: '-h', desc: 'The host of database', type: :string, default: 'localhost'
		method_option :port,      aliases: '-p', desc: 'The port of database', type: :numeric, default: 5432
		method_option :org,      	aliases: '-o', desc: 'The org database name, required:true'
		method_option :main,      	aliases: '-m', desc: 'The database main, required:true' 
		method_option :type,      	aliases: '-t', desc: 'Type of the application', type: :string, default:'PMM'
		method_option :idl,      	aliases: '-i', desc: 'The path of idl files', type: :string, default:'home/idl'
	
		method_option :help,      desc: 'Displays the usage'

		def run_idl
			if options[:help] 

				invoke :help, ['run_idl']
			else

				raise RequiredArgumentMissingError.new("No value provided for required options, run --help for more info") if options[:org].nil? || options[:main].nil?
      
				require 'atd/commands/idl'
				ATD::Commands::IDL.new(environment).start
			end
			end 


		private
		
		def environment
	    ATD::Environment.new(options)
	  end
	end
	
end
