require 'test_helper'

class BedroomsControllerTest < ActionDispatch::IntegrationTest
  test 'render a list of bedrooms' do
    get bedrooms_path

    assert_response :success
    assert_select '.bedroom', 2
  end

  test 'render a detailed bedroom page' do
    get bedroom_path(bedrooms(:Matrimonial))

    assert_response :success
    assert_select '.title', 'Matrimonial Special'
    assert_select '.description', 'Disfruta de blablabla'
    assert_select '.priceNight', 'S/ 300.0'
    assert_select '.maxPersons', '6'
    assert_select '.beds', '2 camas'
  end
end
