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
      options[:customer_token] = options.delete(:customer).token if options[:customer].present?
      authenticated_post '/charges', options
    end

    def self.all # TODO: pagination
      response = authenticated_get '/charges'
      charges = []
      if response.code == 200
        response.parsed_response['response'].each do |charge|
          charges << new(charge)
        end
      end
      charges
    end

    def self.find(token)
      response = authenticated_get "/charges/#{token}"
      new(response.parsed_response['response'])
    end
  end
end