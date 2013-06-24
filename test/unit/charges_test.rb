require 'test_helper'

class ChargesTest < Test::Unit::TestCase
  include TestHelper
  
  def setup
    mock_api('Charges')
  end

  def test_get_all # for some reason `test "get all" do` wasn't working...
    charges = Pin::Charge.all
    assert_equal 1, charges.length

    first = charges.first
    charge = Pin::Charge.find(first.token)
    assert_not_nil charge
  end
end