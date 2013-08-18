class Issues
  def initialize(conf)
    rietveld = Rietveld.new(conf)
    File.open(conf[:id_file]) do |id|
      issue = rietveld.issue(id)
      File::open(conf[:issue_file], 'a') { |f|
        f.puts issue
      }
      sleep(conf[:interval].to_i)
    end
  end
end