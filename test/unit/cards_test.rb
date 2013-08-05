require 'test_helper'

class CardsTest < Test::Unit::TestCase
  include TestHelper
  
  def setup
    mock_post('Cards')
  end

  def test_create
    attributes = {number: '5520000000000000', expiry_month: '12', expiry_year: '2014', cvc: '123', name: 'Roland Robot', address_line1: '42 Sevenoaks St', address_city: 'Lathlain', address_postcode: '6454', address_state: 'WA', address_country: 'Australia'}
    card = Pin::Card.create(attributes)
    assert_not_nil card
    assert_not_nil card.token
  end
end