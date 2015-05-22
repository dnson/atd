require "atd/base/step"
module ATD
  module IData
    class Sanitize < Step
      def initialize(options={})
        @options = options
      end
      def run
        file = options.fetch(:file);

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
