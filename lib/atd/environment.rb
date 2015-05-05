require 'pathname'
require 'dotenv'
require 'lotus/utils/hash'

module ATD
	class Environment

		DEFAULT_CONFIG = 'config'.freeze
		DEFAULT_PORT   = 5432
		DEFAULT_HOST   = 'localhost'.freeze
 		DEFAULT_DOTENV = '.env'.freeze
 		DEFAULT_ENV    = 'development'.freeze
 		DEFAULT_APP_TYPE = 'PMM'.freeze
 		DEFAULT_IDL_PATH = '/home/idl'
 		
		def initialize(options = {})
      @options =  Lotus::Utils::Hash.new(options).symbolize!
      @options = read.merge! @options
    end

    def exist?
      path_file.exist?
    end

    def path_file
      config.join(DEFAULT_DOTENV) 
    end

    def read()
      if exist?
        options_env = Dotenv.load path_file
        Lotus::Utils::Hash.new(options_env).symbolize!
      end
    end
		
		def root
    	@root ||= Pathname.new(Dir.pwd)
    end

    def config
    	@config ||= root.join(@options.fetch(:config) { DEFAULT_CONFIG } )
   	end

   	def host
      @host ||= @options.fetch(:host) {  DEFAULT_HOST  } 
    end
   
   	def environment
      @environment ||=  DEFAULT_ENV
    end
    
    def idl_path
    	@idl_path = @options.fetch(:idl_path) { DEFAULT_IDL_PATH }
    end

    def org
    	@org = @options.fetch(:org)
    end

    def app_type
    	@app_type = @options.fetch(:app_type) { DEFAULT_APP_TYPE }
    end

    def port
      @port ||= @options.fetch(:port) {  DEFAULT_PORT }.to_i
    end

    # run idl_file

    def database
      @database ||= @options.fetch(:database) 
    end
    def username
      @username ||= @options.fetch(:username) 
    end
    def password
      @password ||= @options.fetch(:password) 
    end
    def table
      @table ||= @options.fetch(:table) 
    end
    def seperate
      @seperate ||= @options.fetch(:seperate) 
    end
    def file
      @file ||= @options.fetch(:file) 
    end
    # end run_idl_file



    
    def test
    	@options
    end

    def to_options
      @options.merge(
        host:        host,
        port:        port
      )
    end
	end
end