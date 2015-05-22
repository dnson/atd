require 'csv'
require 'active_record'
require 'rubygems'
require 'digest/sha1'
require 'fileutils'
require 'atd/base/step'
require 'pry-byebug'
module ATD
  module IData
    class ILoad < ATD::Base::Step
      attr_reader :errors
      def initialize(options)
        @errors =[]
        @options = options
      end
      def run

        $tmpfile = "/tmp/#{Digest::SHA1.hexdigest(rand(100000).to_s)}.csv"
        @options[:ext].upcase!
        if (!SUPPORTED_INPUT_FORMATS.include?(@options[:ext]))
          log("Invalid file format, supported: #{SUPPORTED_INPUT_FORMATS.join(', ')}",@options.fetch(:show_log))
          exit
        end

        # Database dump
        ActiveRecord::Base.establish_connection(
          'adapter' => 'postgresql',
          'host' => @options[:host],
          'database' => @options[:database],
          'username' => @options[:username],
          'password' => @options[:password],
          'port' => @options[:port],
          'timeout' => 15000
        )

        $csv_converters = [:stripper]

        CSV::Converters[:stripper] = lambda{ |s|
          if s.is_a?(String)
            r = s.strip
            return nil if r == ""
            return r
          else
            return s
          end
        }
        @options[:port] ||= POSTGRESQL_PORT
        @options[:delim] ||= CSV_DEFAULT_DELIMITER
        @options[:quote] ||= CSV_DEFAULT_QUOTE
        @options[:append] ||= false
        @csv_converters << :null_converter if @options[:null]

        CSV::Converters[:null_converter] = lambda{ |s|
          return nil if s == @options[:null]
          return s
        }

        exec
      end
      def exec(restart=0)
        begin

          e = MyParser.new(@options)
          e.run
        rescue Exception => ex
          if (ex.message =="invalid byte sequence in UTF-8" && restart !=3)
            restart +=1
            log("Reload #{@options.fetch(:file)}",@options.fetch(:show_log))
            @options[:delim] = /\t/
            @options[:quote] = /\b/
            exec(restart)
          else
            log("Couldn't load #{@options.fetch(:file)} #{ex.message}",@options.fetch(:show_log))

          end
        end

      end
    end
    class String
      def underscore
        return self if self.nil?
        return self.strip.gsub(/[^a-z0-9]+/, "_")
      end
    end
    SUPPORTED_INPUT_FORMATS = ['CSV', 'FX', 'RPT']
    POSTGRESQL_PORT = 5432
    CSV_DEFAULT_DELIMITER = ','
    CSV_DEFAULT_QUOTE = '"'
    class MyParser < ATD::Base::Step
      def initialize(options)
        @options = options
        # remote server always requires password
        if !local? and @options[:password].nil?
          raise "You are connecting to a remote server\nPlease make sure you specify SQL password: --password "
        end
      end

      def run
        load_fx if @options[:ext] == 'FX' || @options[:ext] == 'RPT'
        load_csv if @options[:ext] == 'CSV'
      end

      def load_csv
        # Load CSV data from input file to a temp array
        csv_data = []
        CSV.foreach(@options[:file], :col_sep => @options[:delim], :quote_char => @options[:quote], :converters => $csv_converters) do |csv|
          csv_data << csv
        end

        # Serialize array into a new CSV (with standard delimiter, quote) for later use with PostgreSQL
        CSV.open($tmpfile, "wb", :col_sep => CSV_DEFAULT_DELIMITER, :quote_char => CSV_DEFAULT_QUOTE) do |writer|
          csv_data.each do |csv|
            writer << csv
          end
        end

        # Send to PostgreSQL
        create_table_from_csv($tmpfile)
      end

      def load_fx
        # Load data
        data = IO.read(@options[:file]).split("\n")
        header = data.shift
        headers = header.scan(/[^\s]+\s+/)

        # Parse
        ranges = headers.map{|s| "a#{s.size}"}.join("")
        headers.map!{|s| s.downcase.strip }

        # Write
        CSV.open($tmpfile, "wb", :col_sep => CSV_DEFAULT_DELIMITER, :quote_char => CSV_DEFAULT_QUOTE) do |csv|
          csv << headers
          data.each_with_index{|s, index|
            record = s.unpack(ranges).map{|e| e.strip}

            # take advantage of CSV converters
            $csv_converters.each {|converter|
              converter_lambda = CSV::Converters[converter]
              record.map!(&converter_lambda)
            }

            csv << record
          }
        end

        # Send to PostgreSQL
        create_table_from_csv($tmpfile)
      end

      def create_table_from_csv(csv_path)
        # Get headers
        csv = CSV.open(csv_path, :headers => true, :col_sep => CSV_DEFAULT_DELIMITER, :quote_char => CSV_DEFAULT_QUOTE)

        first = csv.first
        unless first
          raise "File Empty!!!"
        end

        # sanitize
        headers = first.headers
        headers.each_with_index {|e, index|
          if e.nil? or e.empty?
            headers[index] = "column_#{index + 1}"
          end
        }
        headers.map!{|e| e.downcase.underscore }

        # check if every field name is unique
        if headers.count != headers.uniq.count
          raise "Field name must be UNIQUE: \nPlease check your input headers: [#{headers.sort.join(', ')}]"
        end

        # Create table
        if !@options[:append]
          drop_table_sql = "drop table if exists #{@options[:table]};"
        else
          drop_table_sql = ""
        end

        create_table_sql = headers.map{|e| "\"#{e}\" text"}.join(",")
        create_table_sql = "create table if not exists #{@options[:table]}( id serial not null, #{create_table_sql} );"
        query(drop_table_sql, create_table_sql)

        insert_data_sql = headers.map{|e| "\"#{e}\""}.join(",")
        insert_data_sql = "COPY #{@options[:table]}( #{insert_data_sql} ) FROM '#{csv_path}' DELIMITER ',' CSV HEADER"

        # Change output file permission so that postgres user can read it
        begin
          FileUtils.chmod 0755, csv_path
        rescue Exception => ex
          puts "Error while changing file permission"
        end

        if local?
          query(insert_data_sql)
        else
          log( "WARNING: pushing data to remote server [#{@options[:host]}].",@options.fetch(:show_log))

          insert_data_sql = "PGPASSWORD=#{@options[:username]} psql -U #{@options[:username]} -h #{@options[:host]} -p #{@options[:port]} #{@options[:database]} -c \"\\#{insert_data_sql}\""

          `#{insert_data_sql}`
          `PGPASSWORD=""`
        end

        log( "Table `#{@options[:table]}` loaded",@options.fetch(:show_log))
      end

      private
      def query(*query_str)
        ActiveRecord::Base.connection.execute(query_str.join("; "))
      end

      def local?
        return ['localhost', '127.0.0.1'].include?(@options[:host])
      end
    end
  end
end
