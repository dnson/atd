require "atd/base/step"
require "atd/base/use_case"

module ATD
  module Flow
    class Base < ATD::Base::Step
      # requires all files recursively inside a directory from current dir
      #     # @param _dir can be relative path like '/lib' or "../lib"
      include ATD::Base::UseCase

      def require_all(_dir)
        Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
          require file
        end
      end

      def perform
        log("Step:Entrance",@environment.show_log)
        run
        log("Step:Done",@environment.show_log)
      end

    end
  end
end
