require "test_helper"

class RecurringBillsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recurring_bills_index_url
    assert_response :success
  end
end
