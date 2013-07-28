## pin-payments

A wrapper for the [pin.net.au](https://pin.net.au/) [API](https://pin.net.au/docs/api). This is Qutonic's fork with a different API. MIT license.

## Usage

### Prerequisites

You'll need to create an account at [pin.net.au](https://pin.net.au/) first.

### Setup

Create an initializer, eg. `pin.rb`:

```ruby
Pin.setup secret_key: 'PIN_SECRET_KEY', publishable_key: 'PIN_PUBLISHABLE_KEY', mode: :test
```

You can get your keys from Pin's [Your Account](https://dashboard.pin.net.au/account) page. The second argument should be `:live` or `:test` depending on which API you want to access. The `publishable_key` is optional.

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

### Usage

You'll probably want to create a form through which users can enter their details. [Pin's guide](https://pin.net.au/docs/guides/payment-forms) will step you through this. The publishable key will be necessary and, if set, can be obtained by calling `Pin.publishable_key`. You can also ask the module for the path to the javascript for the configured mode:

```erb
<%= javascript_include_tag Pin.js_url %>
```

Then, in your controller:

```ruby
def create
  Pin::Charge.create email: 'user@example.com', description: '1 year of service', amount: 10000,
                     currency: 'AUD', ip_address: params[:ip_address], card_token: params[:card_token]
  redirect_to new_payment_path, notice: "Your credit card has been charged"
end
```

This will issue a once-off charge ([API](https://pin.net.au/docs/api/charges)).

For a recurring charge, you may wish to create a customer record at Pin. To do this, either create a `Card` object first, then a corresponding `Customer` via the [API](https://pin.net.au/docs/api/customers); or use a `card_token` returned from `Pin.js` to create a customer. Note that in either case you may activate additional compliance provisions in Pin's [Terms & Conditions](https://pin.net.au/terms).

```ruby
card = Pin::Card.new number: '5520000000000000', expiry_month: '12', expiry_year: '2018', cvc: '123',
                     name: 'User Name', address_line1: 'GPO Box 1234', address_city: 'Melbourne', address_postcode: '3001', address_state: 'VIC', address_country: 'Australia'
customer = Pin::Customer.create 'user@example.com', card # this contacts the API
Pin::Charge.create email: 'user@example.com', description: '1 year of service', amount: 10000,
                   currency: 'AUD', ip_address: '127.0.0.1', customer: customer # shorthand for customer_token: customer.token
```

You can view your customers in the [Pin dashboard](https://dashboard.pin.net.au/test/customers). This lets you charge customers regularly without asking for their credit card details each time.

```ruby
customers = Pin::Customer.all
customer = customers.find {|c| c.email == user.email} # assume user is the user you are trying to charge
Pin::Charge.create email: user.email, description: '1 month of service', amount: 19900, currency: 'AUD',
                   ip_address: user.ip_address, customer: customer
```

Errors from the API will result in a`Pin::APIError` exception being thrown:

```ruby
begin
  response = Pin::Charge.create( ... )
rescue Pin::APIError => e
  redirect_to new_payment_path, flash: { error: "Charge failed: #{e.message}" }
end
```
