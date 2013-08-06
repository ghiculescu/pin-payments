require 'test_helper'

class CustomersTest < Test::Unit::TestCase
  include TestHelper
  
  def setup
    mock_api('Customers')
    mock_post('Cards')
  end

  def test_get_all # for some reason `test "get all" do` wasn't working...
    customers = Pin::Customer.all
    assert_equal 1, customers.length

    first = customers.first
    customer = Pin::Customer.find(first.token)
    assert_not_nil customer
  end

  def test_get_pages_of_customers
    customers = Pin::Customer.all(page: 1)
    assert_equal 1, customers.page

    # TODO: mock this
    #customers = Pin::Customer.all(page: 2)
    #assert_equal 2, customers.page
  end

  def test_create_customer_with_card
    card = Pin::Card.new number: '5520000000000000', expiry_month: '12', expiry_year: '2014', cvc: '123', name: 'Roland Robot', address_line1: '42 Sevenoaks St', address_city: 'Lathlain', address_postcode: '6454', address_state: 'WA', address_country: 'Australia'

    customer = Pin::Customer.create('alex@payaus.com', card)
    assert_not_nil customer
  end

  def test_create_customer_with_token
    card = Pin::Card.create number: '5520000000000000', expiry_month: '12', expiry_year: '2014', cvc: '123', name: 'Roland Robot', address_line1: '42 Sevenoaks St', address_city: 'Lathlain', address_postcode: '6454', address_state: 'WA', address_country: 'Australia'

    customer = Pin::Customer.create('alex@payaus.com', card.token)
    assert_not_nil customer
  end
end