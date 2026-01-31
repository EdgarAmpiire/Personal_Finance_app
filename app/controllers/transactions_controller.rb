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

    # Enforce ownership of foreign keys (this is what Brakeman wants in spirit)
    @transaction.account  = current_user.accounts.find(params[:transaction][:account_id])
    @transaction.category = current_user.categories.find(params[:transaction][:category_id])

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
    # Update base fields + amount_cents
    if @transaction.update(transaction_params)
      # If user is trying to change account/category, enforce ownership
      if params[:transaction][:account_id].present?
        @transaction.update!(account: current_user.accounts.find(params[:transaction][:account_id]))
      end

      if params[:transaction][:category_id].present?
        @transaction.update!(category: current_user.categories.find(params[:transaction][:category_id]))
      end

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

  def transaction_params
    raw = params.require(:transaction).permit(:description, :occurred_on, :amount)

    amount_str = raw.delete(:amount).to_s.strip
    raw[:amount_cents] = (BigDecimal(amount_str) * 100).to_i if amount_str.present?

    raw
  end
end
