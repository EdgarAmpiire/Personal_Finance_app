# app/controllers/recurring_bills_controller.rb
class RecurringBillsController < ApplicationController
  before_action :require_login
  before_action :set_bill, only: %i[show edit update destroy]

  def index
    @q = params[:q].to_s.strip
    @sort = params[:sort].presence || "latest"

    scope = current_user.recurring_bills
    scope = scope.where("title ILIKE ?", "%#{@q}%") if @q.present?

    @bills =
      case @sort
      when "amount_desc" then scope.order(amount_cents: :desc, created_at: :desc)
      when "amount_asc"  then scope.order(amount_cents: :asc, created_at: :desc)
      when "due_day"     then scope.order(due_day: :asc, created_at: :desc)
      else
        scope.order(created_at: :desc)
      end
  end

  def show; end

  def new
    @bill = current_user.recurring_bills.new(active: true)
  end

  def create
    @bill = current_user.recurring_bills.new(bill_params)
    if @bill.save
      redirect_to recurring_bills_path, notice: "Recurring bill created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @bill.update(bill_params)
      redirect_to recurring_bill_path(@bill), notice: "Recurring bill updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bill.destroy
    redirect_to recurring_bills_path, notice: "Recurring bill deleted."
  end

  private

  def set_bill
    @bill = current_user.recurring_bills.find(params[:id])
  end

  def bill_params
    params.require(:recurring_bill).permit(:title, :amount, :due_day, :active, :last_paid_on)
  end
end