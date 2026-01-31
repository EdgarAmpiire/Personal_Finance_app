class TransactionsController < ApplicationController
  before_action :require_login
  before_action :set_transaction, only: %i[show edit update destroy]

  def index
  scope = current_user.transactions.includes(:account, :category)

  if params[:category_id].present?
    scope = scope.where(category_id: params[:category_id])
  end

  if params[:from].present?
    scope = scope.where("occurred_on >= ?", Date.parse(params[:from]))
  end

  if params[:to].present?
    scope = scope.where("occurred_on <= ?", Date.parse(params[:to]))
  end

  @transactions = scope.order(occurred_on: :desc, created_at: :desc).limit(200)

  @categories = current_user.categories.order(:name)
end


  def show
  end

  def new
    @transaction = current_user.transactions.new(occurred_on: Date.current)
    load_form_collections
  end

  def create
    @transaction = current_user.transactions.new(transaction_params)
    if @transaction.save
      redirect_to @transaction, notice: "New transaction created."
    else
      load_form_collections
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_form_collections
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: "Your transaction has been updated."
    else
      load_form_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_path, notice: "Your transaction has been deleted."
  end

  private

  def set_transaction
    @transaction = current_user.transactions.find(params[:id])
  end

  def load_form_collections
    @accounts = current_user.accounts.order(:name)
    @categories = current_user.categories.order(:name)
  end

  # def transaction_params
  #   raw = params.require(:transaction).permit(:account_id, :category_id, :description, :occurred_on, :amount)

  #   # Convert amount -> amount_cents int
  #   cents = (BigDecimal(raw.delete(:amount).to_s) * 100).to_i

  #   raw.merge(amount_cents: cents)
  # end
  def transaction_params
  raw = params.require(:transaction).permit(:account_id, :category_id, :description, :occurred_on, :amount)

  amount_str = raw.delete(:amount)

  # Only convert if amount was provided (create needs it, update might not)
  if amount_str.present?
    cents = (BigDecimal(amount_str.to_s) * 100).to_i
    raw[:amount_cents] = cents
  end

  raw
  end

end
