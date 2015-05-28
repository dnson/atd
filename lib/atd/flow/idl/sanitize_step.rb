require 'atd/idata/sanitize'
module ATD
  module Flow
    module IDL
      class SanitizeStep < ATD::Base::Step
        def initialize(environment)
          @environment = environment
          @show_log = environment.show_log
        end
        def run
          Dir.foreach(@environment.idl_path) do |item|
            next if item == '.' or item =='..'
            file = Pathname.new(@environment.idl_path).join(item)
            options = {:file => file}
            ATD::IData::Sanitize.new(options).perform
          end
        end
      end
    end
  end
end
