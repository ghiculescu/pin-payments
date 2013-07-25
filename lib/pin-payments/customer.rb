module Pin
  class Customer < Base
    attr_accessor :email, :created_at, :token, :card

    # email should be a string
    # card_or_token can be a Pin::Card object
    # or a card_token (as a string)
    def self.create(email, card_or_token)
      options = if card_or_token.respond_to?(:to_hash) # card
        {card: card_or_token.to_hash}
      else # token
        {card_token: card_or_token}
      end.merge(email: email)

      build_instance_from_response(authenticated_post('/customers', options))
    end

    def self.all # TODO: pagination
      build_collection_from_response(authenticated_get('/customers'))
    end

    def self.find(token)
      build_instance_from_response(authenticated_get("/customers/#{token}"))
    end
  end
end