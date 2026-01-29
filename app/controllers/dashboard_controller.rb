class DashboardController < ApplicationController
  before_action :require_login

  def show
    # @accounts = current_user.accounts.order(:name)
    @accounts = current_user.accounts.order(:name)
    @recent_transactions = current_user.transactions
                                       .includes(:account, :category)
                                       .order(occurred_on: :desc, created_at: :desc)
                                       .limit(10)

    @current_balance_cents = @accounts.sum(&:balance_cents)
  end
end
