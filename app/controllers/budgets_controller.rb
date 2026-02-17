class BudgetsController < ApplicationController
  before_action :require_login
  before_action :set_budget, only: %i[edit update destroy show]

  def index
  @budgets = current_user.budgets.includes(:category).order(created_at: :desc)

  start_of_month = Date.current.beginning_of_month
  end_of_month   = Date.current.end_of_month

  month_expenses = current_user.transactions
    .where(occurred_on: start_of_month..end_of_month)
    .where("amount_cents < 0")

  @spent_by_category_cents = month_expenses
    .group(:category_id)
    .sum(Arel.sql("ABS(amount_cents)"))

  @latest_by_category = month_expenses
    .includes(:account, :category)
    .order(occurred_on: :desc, created_at: :desc)
    .group_by(&:category_id)

  @total_limit_cents = @budgets.sum(:limit_cents)

  @total_spent_cents = @budgets.sum do |b|
    @spent_by_category_cents[b.category_id].to_i
  end

  @total_spent_cents = [ @total_spent_cents, @total_limit_cents ].min
  @total_remaining_cents = [ @total_limit_cents - @total_spent_cents, 0 ].max

  # ✅ DONUT: one slice per budget category (shows ALL budgets)
  # Note: 0-spent budgets create 0-sized slices (invisible), so we add a tiny epsilon.
  epsilon = 0.01 # 1 cent in currency units (since Chartkick is using /100.0)

  @budget_donut = @budgets.each_with_object({}) do |b, h|
    name = b.category&.name || "Uncategorized"
    spent_units = @spent_by_category_cents[b.category_id].to_i / 100.0
    h[name] = spent_units.zero? ? epsilon : spent_units
  end

  # Optional: pass colors to the chart for nicer multi-slice look
  @chart_colors = %w[
    #277C78 #F2CDAC #82C9D7 #626070 #C94736 #7B61FF #FFD166 #06D6A0
    #118AB2 #EF476F #073B4C #8AC926 #FFCA3A #1982C4 #6A4C93
  ]
  end

  def show; end

  def new
    @budget = current_user.budgets.new
  end

  def create
    @budget = current_user.budgets.new(budget_params)

    if @budget.save
      redirect_to budgets_path, notice: "Budget created."
    else
      render :new, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    @budget.errors.add(:limit_cents, e.message)
    render :new, status: :unprocessable_entity
  end

  def edit; end

  def update
    if @budget.update(budget_params)
      redirect_to budgets_path, notice: "Budget updated."
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    @budget.errors.add(:limit_cents, e.message)
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @budget.destroy
    redirect_to budgets_path, notice: "Budget deleted."
  end

  private

  def set_budget
    @budget = current_user.budgets.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:category_id, :limit)
  end
end
