# -*- encoding: utf-8 -*-

### Rietveld Crawler
### Kazuki Hamasaki (ashphy@ashphy.com)

require 'yaml'
require 'fileutils'
require 'optparse'

require_relative 'id_list'
require_relative 'issues'

class RietveldCrawler

  module Status
    ID        = 1 << 1
    ISSUE     = 1 << 2
    PATCHSET  = 1 << 3
  end

  PROCESS_DIR = 'proc'

  def initialize( setting_file )
    @conf = YAML.load_file(setting_file)
    @conf[:id_file] ||= 'ids'
    @conf[:issue_file] ||= 'issues'
  end

  def start(start_from)
    IDList.new(@conf) if start_from <= Status::ID
    Issues.new(@conf) if start_from <= Status::ISSUE
  end

end

if __FILE__ == $0
  start_from = 'ID'

  opt = OptionParser.new
  opt.on('-f', '--file VALUE', 'Setting file') {|v| p v }
  opt.on('-s [VALUE]', '--start [VALUE]', 'Start crawling from [ID|ISSUE|PATCHSET]') do |v|
    case v
      when 'ID'
        start_from = Status::ID
      when 'ISSUE'
        start_from = Status::ISSUE
      when 'PATCHSET'
        start_from = Status::PATCHSET
    end
  end
  opt.parse!(ARGV)

  crawler = RietveldCrawler.new(ARGV.shift)
  crawler.start(start_from)
end