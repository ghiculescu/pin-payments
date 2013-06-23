module Pin
  class Base
    include HTTParty
    base_uri "https://test-api.pin.net.au/1"

    def self.setup(key, mode = :live)
      @@auth = {username: key, password: ''}
      mode = mode.to_sym
      uri = if mode == :test
        "https://test-api.pin.net.au/1"
      elsif mode == :live
        "https://api.pin.net.au/1"
      else
        raise "Incorrect API mode! Must be :live or :test (leave blank for :live)."
      end
      base_uri uri
    end

    protected
    def self.authenticated_post(url, body)
      post(url, body: body, basic_auth: @@auth)
    end
    def self.authenticated_get(url, query = {})
      get(url, query: query, basic_auth: @@auth)
    end
  end
end