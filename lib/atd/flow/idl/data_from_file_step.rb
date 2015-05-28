require 'atd/base/step'
require 'atd/idata/iload'
require 'atd/idata/sanitize'
require 'pathname'
module ATD
  module Flow
    module IDL
      class DataFromFileStep < ATD::Base::Step
        def initialize(environment)
          @environment = environment
          @show_log = environment.show_log
        end
        def run
          Dir.foreach(@environment.idl_path) do |item|
            next if item == '.' or item =='..'
            path = Pathname.new(@environment.idl_path).join(item)
            table = path.basename.sub_ext('')
            table = table.to_s
            extname = path.extname
            extname.sub! '.', ''
            options = {:table => table, :file =>path, :ext => extname }
            options =@environment.to_iload_options.merge options
            ATD::IData::ILoad.new(options).perform
          end
        end
      end
    end
  end
end
