require_relative 'spec_helper'

describe RietveldCrawler do
  describe '#start' do
    context 'called with status' do
      before(:each) do
        YAML.stub(:load_file).and_return({})
      end

      it do
        IDList.should_receive(:new).once.ordered
        Issues.should_receive(:new).once.ordered
        RietveldCrawler.new(nil).start(RietveldCrawler::Status::ID)
      end

      it do
        IDList.should_not_receive(:new)
        Issues.should_receive(:new).once.ordered
        RietveldCrawler.new(nil).start(RietveldCrawler::Status::ISSUE)
      end
    end
  end
end