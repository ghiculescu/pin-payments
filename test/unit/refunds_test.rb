require 'test_helper'

class RefundsTest < Test::Unit::TestCase
  include TestHelper
  
  def setup
    mock_api('Charges')
    mock_api('Refunds', false)
  end

  def test_get_all_with_charge
    charge = Pin::Charge.first

    refunds = Pin::Refund.all(charge)
    assert_equal 1, refunds.length
  end

  def test_get_all_with_charge_token
    charge = Pin::Charge.first

    refunds = Pin::Refund.all(charge.token)
    assert_equal 1, refunds.length
  end

  def test_get_refunds_as_charge_method
    charge = Pin::Charge.first

    refunds = charge.refunds
    assert_equal 1, refunds.length
  end
end