class Issues
  def initialize
    @logger = Log4r::Logger.new('Issues')
  end

  def crawl(conf)
    rietveld = Rietveld.new(conf)
    File.open(conf[:id_file]) do |id|
      @logger.info("Obtained Issue for #{id}")
      issue = rietveld.issue(id)
      @logger.debug("Obtained Issue for #{id}")
      File::open(conf[:issue_file], 'a') { |f|
        f.puts issue
      }
      sleep(conf[:interval].to_i)
    end
  end
end