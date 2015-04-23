require 'atd/version'

module ATD

	class Cli < Thor

		desc 'version', 'print atd version'
		def version
			puts "v#{ATD::VERSION}"
		end
	end
end