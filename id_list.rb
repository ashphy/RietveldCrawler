require_relative 'rietveld'

class IDList
  def initialize
    @logger = Log4r::Logger.new('IDList')
  end

  def crawl(conf)
    rietveld = Rietveld.new(conf)
    cursor = ''
    until cursor == nil do
      body = rietveld.search(cursor)
      unless body['results'].size == 0
        @logger.debug("Obtained ID are #{body['results'].size}")
        File::open(conf[:id_file], 'a') { |f|
          f.puts body['results'].join("\n")
        }

        @logger.info("Next cursor is #{body['cursor']}")
        cursor = body['cursor']
      end
      sleep(conf[:interval].to_i)
    end
  end
end