require 'atd/base/step'
require 'pathname'
module ATD
  module Flow
    module IDLFlow
      class DataFromFileStep < ATD::Base::Step
        def initialize(environment)
          @environment = environment
        end
        def run
          Dir.foreach(@environment.idl_path) do |item|
            next if item == '.' or item =='..'
            path = Pathname.new(@environment.idl_path).join(item)
            options = {:table => item, :file =>path }
            options =@environment.to_iload_options.merge options
            ATD::Commands::ILoad.new(options).run
            puts options.fetch(:file)
          end
        end
      end
    end
  end
end
