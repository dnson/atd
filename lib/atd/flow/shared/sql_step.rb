require "atd/commands/console"
module ATD
  module Flow
    module Shared
      class SqlStep < ATD::Base::Step
        def initialize(environment)
          @environment = environment
          @show_log = environment.show_log
        end
        def file
          temp = script_path.join sql_file
          temp.to_s
        end
        def run
          true
        end
        def script_path
          @environment.config.join "script/idl"
        end
        def exec(file)
          temp = @environment
          ATD::Commands::Console.execute(temp.host,temp.port,temp.username,temp.password,file,temp.database)
        end
      end
    end
  end
end
