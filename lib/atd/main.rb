module ATD
  class Main < Thor

    desc 'download [LINK]', "Dowload your music from a specific link"
    method_option :folder, aliases: '-d', desc: 'Choose specific folder to put the downloaded file'
    method_option :fast, type: :boolean, default: false, desc: 'Use multithread to enable faster download, default: false'

    def download(link = nil)
    	tam = "#{link} #{options}"
      Lotus::Logger.new('FOO').info(tam)
    end
  end
end
