require 'faraday'
require 'faraday_middleware'
require 'logger'

require_relative 'server_error'

# Ritveld API Access Class
class Rietveld

  def initialize( conf )
    @conf = conf
    @log = Logger.new(STDOUT)
  end

  # Get Network connection
  def get_connection
    @log.info("Get connection to #{@conf[:base_url]}")
    Faraday.new(:url => @conf[:base_url], :ssl => {:verify => false}) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter Faraday.default_adapter
    end
  end

  # Perform search API
  def search( cursor )
    @log.info("Search with #{cursor}")
    response = get_connection.get '/search', {
        :format     => 'json',
        :keys_only  => 'True',
        :limit      => '1000',
        :cursor     => cursor
    }

    if response.status == 200
      @log.debug("Obtained ID are #{response.body['results'].size}")
      if response.body['results'].size == 0
        @log.debug('The search reached the end')
        return nil
      end

      File::open(@conf[:id_file], 'a') { |f|
        f.puts response.body['results'].join("\n")
      }
    else
      raise "Server Error #{response.status}" #=> ServerError:
    end

    # Next cursor
    @log.info("Next cursor is #{response.body['cursor']}")
    return response.body['cursor']
  end
end