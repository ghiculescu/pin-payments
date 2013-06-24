module Pin
  class Customer < Base
    attr_accessor :email, :created_at, :token, :card

    # email should be a string
    # card_or_token can be a Pin::Card object
    # or a card_token (as a string)
    def self.create(email, card_or_token)
      body = if card_or_token.respond_to?(:to_hash) # card
        {card: card_or_token.to_hash}
      else # token
        {card_token: card_or_token}
      end.merge(email: email)

      authenticated_post '/customers', body
    end

    def self.all # TODO: pagination
      response = authenticated_get '/customers'
      customers = []
      if response.code == 200
        response.parsed_response['response'].each do |customer|
          customers << new(customer)
        end
      end
      customers
    end

    def self.find(token)
      response = authenticated_get "/customers/#{token}"
      new(response.parsed_response['response'])
    end
  end
end