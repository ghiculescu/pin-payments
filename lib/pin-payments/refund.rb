module Pin
  class Refund < Base
    attr_accessor :token,
                  :amount, :currency, :charge,
                  :success, :error_message, :created_at

    class << self
      # provide a charge object, or charge ID, and it will be refunded
      # optionally provide an amount in cents, greater than equal to 100, to refund
      # defaults to the full amount of the charge
      def create(charge_or_charge_id, amount = nil)
        raise "`amount` must be greater than or equal to 100" if !amount.nil? && amount < 100

        super({amount: amount}, path_for(charge_or_charge_id))
      end

      def all(charge_or_charge_id)
        super(path: path_for(charge_or_charge_id))
      end

      protected
      def api_path
        "charges/%s/refunds"
      end

      private
      def path_for(charge_or_charge_id)
        api_path % parse_charge_id(charge_or_charge_id)
      end

      def parse_charge_id(charge_or_charge_id)
        if charge_or_charge_id.respond_to?(:token) # charge
          charge_or_charge_id.token
        else # already an ID
          charge_or_charge_id
        end
      end
    end
  end
end