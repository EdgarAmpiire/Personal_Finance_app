class AccountsController < ApplicationController
  before_action :require_login
  before_action :set_account, only: %i[show edit update destroy]

  def index
    @accounts = current_user.accounts.order(:name)
  end

  def show
    @transactions = @account.transactions.order(occurred_on: :desc).limit(20)
  end

  def new
    @account = current_user.accounts.new
  end

  def create
    @account = current_user.accounts.new(account_params)
    if @account.save
      redirect_to @account, notice: "Your account has been created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: "Your account has been updated."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, status: :see_other, notice: "Your account has been deleted."
  #    @account.destroy
  # redirect_to accounts_path, status: :see_other, notice: "Account deleted."
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
  params.require(:account).permit(:name, :account_type, :starting_balance)
  end
end
