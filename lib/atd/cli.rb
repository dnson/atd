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

				require 'atd/commands/init_data_load'
        ATD::Commands::InitDataLoad.new(environment).start
			end
		end

		desc 'run_idl_file', 'run file for IDL sMSSS'
		method_option :host,      aliases: '-h', desc: 'The host of database', type: :string, default: 'localhost'
		method_option :port,      desc: 'The port of database', type: :numeric, default: 5432
		method_option :database,      	aliases: '-d', desc: 'The database name, required:true'
		method_option :username,      	aliases: '-u', desc: 'The database username, required:true'
		method_option :password,      	aliases: '-p', desc: 'The database password, required:true'
		method_option :file,      	aliases: '-f', desc: 'The file path, required:true'
		method_option :table,      	aliases: '-t', desc: 'The table name in database, required:true', type: :string
		method_option :seperate,      	aliases: '-s', desc: 'Text delimiter required:true', type: :string, enum: ['comma','space'], default: 'space'
		method_option :use_config,     desc: 'Use config fiel', type: :boolean, default: false
    method_option :show_log, desc: "Show application log or not", type: :boolean, default: false
		method_option :help,      desc: 'Displays the usage'

		def run_idl_file
			if options[:help]

				invoke :help, ['run_idl_file']
			else

				# raise RequiredArgumentMissingError.new("No value provided for required options, run --help for more info") if options[:database].nil? || options[:table].nil? || options[:table].nil?

				require 'atd/commands/init_data_load'
				ATD::Commands::InitDataLoad.new(environment).run_idl_file
			end
		end


		private

			def environment
		    ATD::Environment.new(options)
		  end
	end

end
