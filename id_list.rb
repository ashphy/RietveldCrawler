require_relative 'rietveld'

class IDList
  def initialize( conf )
    rietveld = Rietveld.new(conf)
    cursor = ''
    until cursor == nil do
      cursor = rietveld.search(cursor)
      sleep(conf[:interval].to_i)
    end
  end
end