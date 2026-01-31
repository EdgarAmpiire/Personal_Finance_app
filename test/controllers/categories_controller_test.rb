require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    assert_difference("Category.count", 1) do
      post categories_url, params: {
        category: {
          name: "Food"
        }
      }
    end

    # change this if your controller redirects somewhere else
    assert_redirected_to categories_url
  end
end
