require "test_helper"

class RecurringBillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
  end

  test "should get index" do
    get recurring_bills_url
    assert_response :success
  end
end
