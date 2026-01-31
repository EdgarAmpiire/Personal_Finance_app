require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
    @transaction = transactions(:one)
  end

  test "should get index" do
    get transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_transaction_url
    assert_response :success
  end

  test "should show transaction" do
    get transaction_url(@transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_transaction_url(@transaction)
    assert_response :success
  end

  test "should create transaction" do
    assert_difference("Transaction.count", 1) do
      post transactions_url, params: {
        transaction: {
          account_id: accounts(:one).id,
          category_id: categories(:one).id,
          description: "Test transaction",
          occurred_on: Date.current,
          amount: "10.50" # string is best for BigDecimal conversion
        }
      }
    end

    assert_redirected_to transaction_url(Transaction.last)
  end

  test "should update transaction" do
    transaction = transactions(:one)

    patch transaction_url(transaction), params: {
      transaction: {
        description: "Updated description",
        occurred_on: Date.current,
        amount: "12.50",
        account_id: accounts(:one).id,
        category_id: categories(:one).id
      }
    }

    assert_redirected_to transaction_url(transaction)
  end

  test "should destroy transaction" do
    assert_difference("Transaction.count", -1) do
      delete transaction_url(@transaction)
    end

    assert_redirected_to transactions_url
  end
end
