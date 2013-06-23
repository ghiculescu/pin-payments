## pin-payments

A wrapper for the [pin.net.au](https://pin.net.au/) [API](https://pin.net.au/docs/api). Available via [RubyGems](http://rubygems.org/gems/pin-payments):

    gem install pin-payments

Extracted from [PayAus](http://www.payaus.com/)

MIT licensed.

## Usage

### Prerequisites

You'll need to create an account at [pin.net.au](https://pin.net.au/) first.

### Setup

Create an initializer, eg. `pin.rb`:

```ruby
Pin::Base.setup ENV['PIN_SECRET_KEY'], ENV['PIN_ENV']
```

You can get your secret key from Pin's [Your Account](https://dashboard.pin.net.au/account) page. The second argument should be "live" or "test" depending on which API you want to access.

### Usage

You'll probably want to create a form through which users can enter their details. [Pin's guide](https://pin.net.au/docs/guides/payment-forms) will step you through this.

Then, in your controller:

```ruby
def create
  Pin::Charge.create email: 'alex@payaus.com', description: '1 month of service', amount: 19900,
                     currency: 'AUD', ip_address: params[:ip_address], card_token: params[:card_token]
  redirect_to new_payment_path, notice: "Your credit card has been charged"
end
```

This will issue a once-off charge ([API](https://pin.net.au/docs/api/charges)). Alternatively, you may wish to create a customer. To do this, create a `Card` object first, then a corresponding `Customer` via the [API](https://pin.net.au/docs/api/customers).

```ruby
card = Pin::Card.new number: '5520000000000000', expiry_month: '12', expiry_year: '2014', cvc: '123',
                     name: 'Roland Robot', address_line1: '42 Sevenoaks St', address_city: 'Lathlain', address_postcode: '6454', address_state: 'WA', address_country: 'Australia'
customer = Pin::Customer.create 'alex@payaus.com', card # this contacts the API
Pin::Charge.create email: 'alex@payaus.com', description: '1 month of service', amount: 19900,
                   currency: 'AUD', ip_address: '203.192.1.172', customer: customer # shorthand for customer_token: customer.token
```

You can view your customers in the [Pin dashboard](https://dashboard.pin.net.au/test/customers). This lets you charge customers regularly without asking for their credit card details each time.

```ruby
customers = Pin::Customer.all
customer = customers.find {|c| c.email == user.email} # assume user is the user you are trying to charge
Pin::Charge.create email: user.email, description: '1 month of service', amount: 19900, currency: 'AUD',
                   ip_address: user.ip_address, customer: customer
```