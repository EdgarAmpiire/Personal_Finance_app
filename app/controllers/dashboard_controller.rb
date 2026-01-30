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

    start_of_month = Date.current.beginning_of_month
    end_of_month = Date.current.end_of_month

    month_scope = current_user.transactions.where(occurred_on: start_of_month..end_of_month)

    @month_income_cents = month_scope.where("amount_cents > 0").sum(:amount_cents)
    @month_expense_cents = month_scope.where("amount_cents < 0").sum(:amount_cents).abs

    # Chart: spending by category (expenses only)
    @spend_by_category = month_scope
        .where("amount_cents < 0")
        .joins("LEFT JOIN categories ON categories.id = transactions.category_id")
        .group("COALESCE(categories.name, 'Uncategorized')")
        .sum("ABS(transactions.amount_cents)")
  end
end
