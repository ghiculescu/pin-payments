## pin-payments

A wrapper for the [pin.net.au](https://pin.net.au/) [API](https://pin.net.au/docs/api). MIT licensed.

## Installation

Available via [RubyGems](https://rubygems.org/gems/pin-payments). Install the usual way;

    gem install pin-payments

## Build Status

[![Build status](https://travis-ci.org/ghiculescu/pin-payments.png)](https://travis-ci.org/ghiculescu/pin-payments)

## Usage

### Prerequisites

You'll need to create an account at [pin.net.au](https://pin.net.au/) first.

### Setup

Create an initializer, eg. `pin.rb`, using keys from Pin's [Your Account](https://dashboard.pin.net.au/account) page.

```ruby
Pin.setup secret_key: ENV['PIN_SECRET_KEY'], publishable_key: ENV['PIN_PUBLISHABLE_KEY'], mode: ENV['PIN_ENV']
```

The `mode` should be `:live` or `:test` depending on which API you want to access. The `publishable_key` is optional.

Alternatively, you could fetch keys from a YAML file, e.g. like this initializer:

```ruby
pin_config_path = Rails.root.join 'config', 'pin.yml'
if File.exists?(pin_config_path)
  configuration = YAML.load_file(pin_config_path)
  raise "No environment configured for Pin for RAILS_ENV=#{Rails.env}" unless configuration[Rails.env]
  Pin.setup configuration[Rails.env].symbolize_keys
end
```

and then in `config/pin.yml`:

```yaml
test:
  secret_key: "TEST_API_SECRET"
  publishable_key: "TEST_PUBLISHABLE_KEY"
  mode: "test"

development:
  secret_key: "TEST_API_SECRET"
  publishable_key: "TEST_PUBLISHABLE_KEY"
  mode: "test"

production:
  secret_key: "LIVE_API_SECRET"
  publishable_key: "LIVE_PUBLISHABLE_KEY"
  mode: "live"
```

This allows you to inject `pin.yml` at deployment time, so that the secret key can be kept separate from your codebase.

### JavaScript Helpers

You'll probably want to create a form through which users can enter their details. [Pin's guide](https://pin.net.au/docs/guides/payment-forms) will step you through this. The publishable key will be necessary and, if set, can be obtained by calling `Pin.publishable_key`. So for example, you could have at the bottom of your form:

```javascript
$('form.pin').pinForm('<%= Pin.publishable_key %>')
```

You also need to include [Pin.js](https://pin.net.au/pin-js) in pages that will talk to Pin via JavaScript. You can easily do this (and load the appropriate live or test version of pin.js) by doing:

```erb
<%= javascript_include_tag Pin.js_url %>
```

### Charges

[API Documentation](https://pin.net.au/docs/api/charges)

**Creating a charge**

```ruby
def create
  Pin::Charge.create email: 'user@example.com',
                     description: '1 year of service', amount: 10000,
                     currency: 'AUD',
                     ip_address: params[:ip_address],
                     card_token: params[:card_token]
end
```

This will issue a once-off charge. Generally it's a good practice to do this in a background job and not directly in the controller. You can also create a charge against a customer token, once you have saved a customer (more details below).

```ruby
Pin::Charge.create email: 'user@example.com',
                   description: '1 year of service', amount: 10000,
                   currency: 'AUD',
                   ip_address: params[:ip_address],
                   customer_token: customer.token
```

**Retrieving charges**

```ruby
# get all charges
Pin::Charge.all

# get a charge with token "ch_lfUYEBK14zotCTykezJkfg"
Pin::Charge.find("ch_lfUYEBK14zotCTykezJkfg")
```

### Customers

[API Documentation](https://pin.net.au/docs/api/customers)

For a recurring charge, you may wish to create a customer record at Pin. To do this, either create a `Card` object first, then a corresponding `Customer` via the [API](https://pin.net.au/docs/api/customers); or use a `card_token` returned from `Pin.js` to create a customer. Note that in either case you may activate additional compliance provisions in Pin's [Terms & Conditions](https://pin.net.au/terms).

**Creating a customer**

```ruby
# this doesn't contact the API
card = Pin::Card.new number: '5520000000000000', expiry_month: '12', expiry_year: '2018', cvc: '123',
                     name: 'User Name', address_line1: 'GPO Box 1234', address_city: 'Melbourne',
                     address_postcode: '3001', address_state: 'VIC', address_country: 'Australia'

# create a customer using a card object
customer = Pin::Customer.create 'user@example.com', card

# you can also create a customer using a card token - for example, in a controller
def create
  customer = Pin::Customer.create 'user@example.com', params[:card_token]
end
```

**Retrieving a customer**

```ruby
# get all customers
Pin::Customer.all

# get a customer with token "cus_XZg1ULpWaROQCOT5PdwLkQ"
Pin::Customer.find("cus_XZg1ULpWaROQCOT5PdwLkQ")
```

### Refunds

[API Documentation](https://pin.net.au/docs/api/refunds)

Refunds work based on charges, so you'll need a charge first.

```ruby
charge = Pin::Charge.first
```

Create a refund:

```ruby
# provide an amount to refund that amount - defaults to refunding the full amount
# both methods do the same thing
charge.refund!(250)
Pin::Refund.create(charge, 250)
```

Get refunds for this charge:

```ruby
# both do the same thing
refunds = charge.refunds
refunds = Pin::Refund.all(charge)
```

### Card Tokens

[API Documentation](https://pin.net.au/docs/api/cards)

Given a credit card, store it in Pin and get a card token in exchange:

```ruby
# contact the API and get a card token
card = Pin::Card.create number: '5520000000000000', expiry_month: '12', expiry_year: '2018', cvc: '123',
                        name: 'User Name', address_line1: 'GPO Box 1234', address_city: 'Melbourne',
                        address_postcode: '3001', address_state: 'VIC', address_country: 'Australia'
token = card.token
```

You can then use this token to create a customer or make a charge. If possible, it is better practice to create card tokens using `Pin.js` and only pass on the required information (ie. the card token and IP address) to your server.

### Errors

Errors from the API will result in a`Pin::APIError` exception being raised:

```ruby
begin
  response = Pin::Charge.create( ... )
rescue Pin::APIError => e
  redirect_to new_payment_path, flash: { error: "Charge failed: #{e.message}" }
end
```

## License

MIT

## Contributors

https://github.com/ghiculescu/pin-payments/graphs/contributors