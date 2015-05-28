require "atd/base/step"
module ATD
  module IData
    class Sanitize < ATD::Base::Step
      def initialize(options={})
        @options = options
        @options[:remove] =  []
      end
      def run
        begin
          file = @to_iload_options.fetch(:file);
          sanitize(file)
          log("File #{file} has sanitized")
         rescue Exception => ex
          log(ex.message, @show_log)
        end
      end
      def sanitize(file)
	      s = IO.read(file)

  	    # Remove invalid UTF-8 byte code
  	    s = s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')

  	    # remove ending newlines
  	    if @options[:strip_newline]
    	    s.gsub!(/(\r*\n)$/m, "")
  	    end

  	    # Remove wrong char
  	    @options[:remove].each do |c|
    		  s.gsub!([c.to_i].pack("U"), "")
  	    end

  	    # Write back
  	    File.open(file, 'wb') {|f| f.write(s)}
      end
    end
  end
end
