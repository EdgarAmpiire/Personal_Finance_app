class DashboardController < ApplicationController
  before_action :require_login

  def show
    # @accounts = current_user.accounts.order(:name)
    @accounts = current_user.accounts.order(:name)
    @recent_transactions = current_user.transactions
                                       .includes(:account, :category)
                                       .order(occurred_on: :desc, created_at: :desc)
                                       .limit(10)

    @current_balance_cents =
      current_user.accounts.sum("COALESCE(starting_balance_cents, 0)") +
      current_user.transactions.sum(:amount_cents)

    start_of_month = Date.current.beginning_of_month
    end_of_month = Date.current.end_of_month

    month_scope = current_user.transactions.where(occurred_on: start_of_month..end_of_month)

    @month_income_cents = month_scope.where("amount_cents > 0").sum(:amount_cents)
    @month_expense_cents = month_scope.where("amount_cents < 0").sum(:amount_cents).abs

    # Chart 1: spending by category (expenses only)
    @spend_by_category_cents = month_scope
      .where("amount_cents < 0")
      .left_joins(:category)
      .group("COALESCE(categories.name, 'Uncategorized')")
      .sum(Arel.sql("ABS(transactions.amount_cents)"))


  # Convert to currency units for Chartkick
  # @spend_by_category = @spend_by_category_cents.transform_values { |c| c.to_i / 100.0 }
  @spend_by_category = (@spend_by_category_cents || {}).transform_values { |c| c.to_i / 100.0 }

    # Chart 2: Income vs Expenses (basic chart requirement)
    @income_vs_expense = {
      "Income" => (@month_income_cents.to_i / 100.0),
      "Expenses" => (@month_expense_cents.to_i / 100.0)
    }
  end
end
