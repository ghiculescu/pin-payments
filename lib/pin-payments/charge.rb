module Pin
  class Charge < Base
    attr_accessor :token,
                  :email, :description, :amount, :currency, :ip_address,
                  :card, :card_token, :customer_token,
                  :success, :status_message, :error_message, :transfer, :created_at

    # options should be a hash with the following params
    # email, description, amount, currency, ip_address are mandatory
    # identifier must be a hash, can take the forms
    #   {card: <Pin::Card>}
    #   {card_token: String<"...">}
    #   {customer_token: String<"...">}
    #   {customer: <Pin::Customer>}
    # eg. {email: 'alex@payaus.com', description: '1 month of PayAus', amount: 19900, currency: 'AUD', ip_address: '203.192.1.172', customer_token: 'asdf'}
    def self.create(options = {})
      options[:customer_token] = options.delete(:customer).token unless options[:customer].nil?
      build_collection_from_response(authenticated_post('/charges', options))
    end

    def self.all # TODO: pagination
      build_collection_from_response(authenticated_get('/charges'))
    end

    def self.find(token)
      build_instance_from_response(authenticated_get("/charges/#{token}"))
    end
  end
end