require 'test_helper'

class CustomersTest < Test::Unit::TestCase
  include TestHelper
  
  def setup
    mock_api('Customers')
  end

  def test_get_all # for some reason `test "get all" do` wasn't working...
    customers = Pin::Customer.all
    assert_equal 1, customers.length

    first = customers.first
    customer = Pin::Customer.find(first.token)
    assert_not_nil customer
  end
end