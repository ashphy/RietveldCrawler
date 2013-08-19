require 'log4r'
require 'faraday'
require 'faraday_middleware'

require_relative 'server_error'

# Ritveld API Access Class
class Rietveld

  def initialize(conf)
    @logger = Log4r::Logger.new('Rietveld')
    @conf = conf
  end

  # Get Network connection
  def get_connection
    @logger.info("Get connection to #{@conf[:base_url]}")
    Faraday.new(:url => @conf[:base_url], :ssl => {:verify => false}) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter Faraday.default_adapter
    end
  end

  # Perform search API
  def search(cursor)
    @logger.info("Search with #{cursor}")
    response = get_connection.get '/search', {
        :format     => 'json',
        :keys_only  => 'True',
        :limit      => '1000',
        :cursor     => cursor
    }

    if response.status == 200
        return response.body['results']
    else
      raise "Server Error #{response.status}" #=> ServerError:
    end
  end

  def issue(issue)
    @logger.info("Issue with #{issue}")
    response = get_connection.get "/api/#{issue}", {
        :messages => true
    }

    if response.status == 200
      return response.body.to_json
    else
      raise "Server Error #{response.status}" #=> ServerError:
    end
  end
end