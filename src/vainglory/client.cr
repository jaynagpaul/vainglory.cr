require "cossack"
require "URI"

module Vainglory
  class Client
    def initialize(apikey, datacenter = "dc01")
      base_url = "https://api.#{datacenter}.gamelockerapp.com/"

      @cossack = Cossack::Client.new base_url do |client|
        client.headers["Authorization"] = apikey
        client.headers["Accept"] = "application/vnd.api+json"
      end
    end

    def status
      get("status")
    end

    def matches(name, region = "na", params = {"" => ""})
      get("matches", region, params)
    end

    def get(path, region = "", params = {"" => ""})
      if region != ""
        region = "shards/#{region}/"
      end

      url = region + path

      return @cossack.get url do |req|
        req.uri.query = add_params(req.uri, params)
      end
    end

    # Add URI query to Hash(String: String)
    private def add_params(url : URI, query : Cossack::Params) : String
      begin
        params = HTTP::Params.parse url.query.not_nil!

        query.each do |key, value|
          params.add key, value
        end
      rescue # query is nil
      end
      return params.to_s
    end
  end
end
