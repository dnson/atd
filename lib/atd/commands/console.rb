require 'rubygems'
require 'popen4'

module ATD
	module Commands
		class Console

			def initialize(environment)
				@environment = environment
			end
			def start
				puts @environment.config
			end
			def self.run_popen4(cmd,showlog=false)
				status =
			    POpen4::popen4(cmd) do |stdout, stderr, stdin, pid|
			      stdin.puts "echo hello world!"
			      stdin.puts "echo ERROR! 1>&2"
			      stdin.puts "exit"
			      stdin.close
			      if (showlog)
				      puts "pid        : #{ pid }"
				      puts "stdout     : #{ stdout.read.strip }"
				      puts "stderr     : #{ stderr.read.strip }"
				    end
			  	end
			  if (showlog)
				  puts "status     : #{ status.inspect }"
				  puts "exitstatus : #{ status.exitstatus }"
				end
			end																																																																																											
			def self.run_system(cmd,showlog=false)
				log = system "bash", "-c", cmd
				# puts log if showlog
			end

		end
	end
end	