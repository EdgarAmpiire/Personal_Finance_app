require "test_helper"

class PotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
  end
  test "should get index" do
    get pots_url
    assert_response :success
  end
end
