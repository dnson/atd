require "atd/flow/shared/sql_step"
module ATD
  module Flow
    module IDL
      class LoadCountryStep < ATD::Flow::Shared::SqlStep
        def initialize(environment)
          @environment = environment
          @show_log = environment.show_log
        end

        def sql_file
          "1_load_countries.sql"
        end
        def commit
          exec file
        end
        def rollback
        end
      end
    end
  end
end
