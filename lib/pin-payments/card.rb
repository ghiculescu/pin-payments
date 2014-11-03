module Pin
	class Card < Base
    attr_accessor :number, :expiry_month, :expiry_year, :cvc, :name, :address_line1,
                  :address_line2, :address_city, :address_postcode, :address_state,
                  :address_country,
                  :token, :display_number, :scheme, :primary

    def initialize(attributes = {})
      attributes.each {|name, value| send("#{name}=", value)}
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
      hash
    end

    class << self
      # options should be a hash with the following keys:
      # :number, :expiry_month, :expiry_year, :cvc, :name, :address_line1,
      # :address_city, :address_postcode, :address_state, :address_country
      #
      # it can also have the following optional keys:
      # :address_line2
      def create(options = {})
        super(options)
      end
    end
  end
end