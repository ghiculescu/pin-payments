module Pin
  class Base
    include HTTParty

    def initialize(attributes = {})
      attributes.each do |name, value|
        if name == 'card' # TODO: this should be generalised (has_one relationship i suppose)
          self.card = Card.new value
        else
          send("#{name}=", value)
        end
      end
    end

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
    def self.authenticated_get(url, query = nil)
      get(url, query: query, basic_auth: @@auth)
    end

    def self.build_instance_from_response(response)
      new(response.parsed_response['response'])
    end

    def self.build_collection_from_response(response)
      models = []
      if response.code == 200
        response.parsed_response['response'].each do |model|
          models << new(model)
        end
      end
      models
    end
  end
end