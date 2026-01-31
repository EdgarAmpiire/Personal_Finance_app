require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sign_up_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post sign_up_url, params: { user: { email: "new@example.com", password: "password", password_confirmation: "password" } }
    end

    assert_redirected_to dashboard_url
  end
end
