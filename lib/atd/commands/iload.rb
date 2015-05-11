require 'rubygems'
module ATD
  module Commands
    class ILoad
      def initialize(options={})
        @options = options
      end
      def run
        puts @options.fetch(:database)
        system "bash", "-c", "iload --host=#{@options.fetch(:host)} --listen=#{@options.fetch(:port)} --username=#{@options.fetch(:username)} --password=#{@options.fetch(:password)} --database=#{@options.fetch(:database)} -i #{@options.fetch(:file)} --format=csv --table=mercy_contract_20150505"

      end
    end
  end
end
