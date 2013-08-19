require_relative 'spec_helper'

describe RietveldCrawler do
  describe '#start' do
    context 'called with status' do
      before(:each) do
        YAML.stub(:load_file).and_return({})
      end

      it do
        id_list = double('IDList')
        id_list.should_receive(:crawl).once.ordered
        IDList.stub(:new).and_return(id_list)

        issues = double('issues')
        issues.should_receive(:crawl).once.ordered
        Issues.stub(:new).and_return(issues)

        RietveldCrawler.new(nil).start(RietveldCrawler::Status::ID)
      end

      it do
        id_list = double('IDList')
        id_list.should_not_receive(:crawl)
        IDList.stub(:new).and_return(id_list)

        issues = double('issues')
        issues.should_receive(:crawl).once.ordered
        Issues.stub(:new).and_return(issues)

        RietveldCrawler.new(nil).start(RietveldCrawler::Status::ISSUE)
      end
    end
  end
end