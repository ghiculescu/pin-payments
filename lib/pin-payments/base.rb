module Pin
  class Base
    include HTTParty

    def initialize(attributes = {})
      attributes.each do |name, value|
        if name == 'card' # TODO: this should be generalised (has_one relationship i suppose)
          self.card = Card.new value
        else
          send("#{name}=", value) if respond_to? "#{name}="
        end
      end
    end

    class << self

      def create(options, path = api_path)
        response = authenticated_post(path, options)
        if response.code == 201 # object created
          build_instance_from_response(response)
        else
          raise Pin::APIError.new(response)
        end
      end
      
      def all(path = api_path) # TODO: pagination
        build_collection_from_response(authenticated_get(path))
      end

      def first(path = api_path)
        all(path).first
      end
      def last(path = api_path)
        all(path).last
      end

      def find(token, path = api_path)
        build_instance_from_response(authenticated_get("#{path}/#{token}"))
      end
    
    protected
    
      def auth
        Pin.auth
      end
    
      def api_path
        short = if i = name.rindex('::')
          name[(i+2)..-1]
        else
          name
        end
        "/#{short}s".downcase
      end
    
      def authenticated_post(url, body)
        post(url, body: body, basic_auth: auth)
      end
      def authenticated_get(url, query = nil)
        get(url, query: query, basic_auth: auth)
      end

      def build_instance_from_response(response)
        new(response.parsed_response['response'])
      end

      def build_collection_from_response(response)
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
end