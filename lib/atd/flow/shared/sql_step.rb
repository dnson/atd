require "atd/commands/console"
module ATD
  module Flow
    module Shared
      class SqlStep < ATD::Base::Step
        def initialize(environment)
          @environment = environment
        end
        def exec(file)
          temp = @environment
          ATD::Commands::Console.execute(temp.host,temp.port,temp.username,temp.password,file,temp.database)
        end
      end
    end
  end
end
