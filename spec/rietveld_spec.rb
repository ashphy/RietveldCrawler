require 'rspec'
require 'webmock/rspec'

require_relative 'spec_helper'

describe Rietveld do

  let(:conf) do
    { base_url: 'https://example.com/', interval: '0',  id_file: 'ids', issue_file: 'issues'}
  end

  describe '#search' do

    def get_site_url_with_cursor(cursor)
      "#{conf[:base_url]}search?cursor=#{cursor}&format=json&keys_only=True&limit=1000"
    end

    let(:site_url) {
      "#{conf[:base_url]}search?cursor&format=json&keys_only=True&limit=1000"
    }

    let(:normal_cursor) {
      'E-ABAOsB8gEIbW9kaWZpZWT6AQkI2J-H0PPvuALsAYICKWoXc35jaHJvbWl1bWNvZGVyZXZpZXctaHJyDgsSBUlzc3VlGI2S5goMFA=='
    }

    let(:req_cursor) {
      ''
    }

    context 'when the normal search request' do
      let(:body) {
        %Q({ "cursor": "#{normal_cursor}", "results": [22776003, 22401006] })
      }

      it do
        stub_request(:get, site_url).to_return({
          body: body,
          status: 200,
          headers: {'content-type' => ':application/json; charset=utf-8'}
        })
        rietveld = Rietveld.new(conf)
        ret = rietveld.search(nil)
        ret.should == normal_cursor
      end
    end

    context 'when the request has 2 pages' do
      let(:body) {
        %Q({ "cursor": "#{normal_cursor}", "results": [22776003, 22401006] })
      }

      it do
        stub_request(:get, site_url).to_return({
          body: body,
          status: 200,
          headers: {'content-type' => ':application/json; charset=utf-8'}
        })

        stub_request(:get, get_site_url_with_cursor(normal_cursor)).to_return({
          body: body,
          status: 200,
          headers: {'content-type' => ':application/json; charset=utf-8'}
        })

        rietveld = Rietveld.new(conf)
        ret = rietveld.search(nil)
        ret.should == normal_cursor

        ret = rietveld.search(ret)
        ret.should == normal_cursor
      end
    end

    context 'when the search query reach the end' do
      let(:body) {
        %Q({ "cursor": "#{normal_cursor}", "results": [] })
      }

      it do
        stub_request(:get, site_url).to_return({
          body: body,
          status: 200,
          headers: {'content-type' => ':application/json; charset=utf-8'}
        })
        rietveld = Rietveld.new(conf)
        ret = rietveld.search(nil)
        ret.should be_nil
      end
    end

  end

  describe '#issue' do
    let(:site_url) {
      "#{conf[:base_url]}api/1234?messages=true"
    }

    context 'when exit issue is given' do
      let(:body) {<<-EOJ
      {
        "description": "Remove ViewActivationChanged() from AppListControllerDelegate.",
        "cc": ["chromium-reviews@chromium.org"],
        "reviewers": ["benwells@chromium.org"],
        "messages": [
          {
            "sender": "koz@chromium.org",
            "recipients": ["koz@chromium.org"],
            "text": "",
            "disapproval": false,
            "date": "2013-08-16 06:21:14.612750",
            "approval": false
          }
        ],
        "owner_email": "koz@chromium.org",
        "private": false,
        "base_url": "svn:\/\/svn.chromium.org\/chrome\/trunk\/src",
        "owner": "koz",
        "subject": "Remove ViewActivationChanged() from AppListControllerDelegate.",
        "created": "2013-08-16 06:08:45.791300",
        "patchsets": [1,7001],
        "modified": "2013-08-18 08:02:40.424660",
        "closed": false,
        "commit": false,
        "issue": 23020012
      }
      EOJ
      }

      it do
        stub_request(:get, site_url).to_return({
          body: body.gsub(/[\r\n\s]/, ''),
          status: 200,
          headers: {'content-type' => ':application/json; charset=utf-8'}
        })
        rietveld = Rietveld.new(conf)
        ret = rietveld.issue('1234')
        ret.should == body.gsub(/[\r\n\s]/, '')
      end
    end
  end
end