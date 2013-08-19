require_relative 'rietveld'

class IDList
  def initialize( conf )
    rietveld = Rietveld.new(conf)
    cursor = ''
    until cursor == nil do
      body = rietveld.search(cursor)
      if body['results'].size == 0
        log.debug("Obtained ID are #{body['results'].size}")
        File::open(conf[:id_file], 'a') { |f|
          f.puts body['results'].join("\n")
        }
      else
        log.info("Next cursor is #{body['cursor']}")
        cursor = body['cursor']
      end
      sleep(conf[:interval].to_i)
    end
  end
end