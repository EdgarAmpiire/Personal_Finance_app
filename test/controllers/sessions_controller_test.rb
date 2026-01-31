require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sign_in_url
    assert_response :success
  end

  test "should create session" do
    post sign_in_url, params: { email: users(:one).email, password: "password" }
    assert_redirected_to dashboard_url
  end

  test "should destroy session" do
    sign_in_as(users(:one))
    delete sign_out_url
    assert_redirected_to sign_in_url
  end
end
