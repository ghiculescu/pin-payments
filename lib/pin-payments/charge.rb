module Pin
  class Charge < Base
    attr_accessor :token,
                  :email, :description, :amount, :currency, :ip_address,
                  :card, :card_token, :customer_token,
                  :amount_refunded, :total_fees, :merchant_entitlement, :refund_pending,
                  :success, :status_message, :error_message, :transfer, :created_at

    attr_accessor :refunds

    class << self
      # options should be a hash with the following params
      # email, description, amount, currency, ip_address are mandatory
      # identifier must be a hash, can take the forms
      #   {card: <Pin::Card>}
      #   {card_token: String<"...">}
      #   {customer_token: String<"...">}
      #   {customer: <Pin::Customer>}
      # eg. {email: 'user@example.com', description: 'One month subscription', amount: 19900, currency: 'USD', ip_address: '192.0.0.1', customer_token: 'asdf'}
      def create(options = {})
        options[:customer_token] = options.delete(:customer).token unless options[:customer].nil?
        super(options)
      end

      # search for charges using parameters provided in options
      # available parameters:
      #   query (string)
      #   start_date (date, or string formatted as 'YYYY-MM-DD')
      #   end_date (date, or string formatted as 'YYYY-MM-DD')
      #   sort (string or symbol: "created_at" (default), "description", or "amount")
      #   direction ("asc"/"desc", or 1/-1)
      def search(options = {})
        options[:direction] = options[:direction] == 'asc' ? 1 : -1 if ['asc', 'desc'].include?(options[:direction])
        build_collection_from_response(authenticated_get('/charges/search', options))
      end
    end

    # find all refunds for the current Charge object
    # returns a list of Refunds
    def refunds
      Refund.all(token)
    end

    # creates a refund for this Charge
    # refunds the full amount of the charge by default, provide an amount in cents to override
    def refund!(amnt = nil)
      Refund.create(token, amnt)
    end
  end
end