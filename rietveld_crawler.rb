# -*- encoding: utf-8 -*-

### Rietveld Crawler
### Kazuki Hamasaki (ashphy@ashphy.com)

require 'yaml'
require 'fileutils'
require 'optparse'

require_relative 'id_list'

class RietveldCrawler

  PROCESS_DIR = 'proc'

  def initialize( setting_file )
    @conf = YAML.load_file(setting_file)
    @conf[:id_file] ||= 'ids'
  end

  def start
    IDList.new( @conf )
  end

end

if __FILE__ == $0
  opt = OptionParser.new
  opt.on('-f', '--file VALUE', 'Setting file') {|v| p v }
  opt.on('-s [VALUE]', '--start [VALUE]', 'Start crawling from [ID|ISSUE|]') {|v| p v}
  opt.parse!(ARGV)

  crawler = RietveldCrawler.new(ARGV.shift)
  crawler.start
end