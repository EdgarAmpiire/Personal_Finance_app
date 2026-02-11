class PotsController < ApplicationController
  before_action :require_login
  before_action :set_pot, only: %i[show edit update destroy add_money withdraw_money]

  def index
    @pots = current_user.pots.order(created_at: :desc)
  end

  def show; end

  def new
    @pot = current_user.pots.new
  end

  def create
    @pot = current_user.pots.new(pot_params)

    if @pot.save
      redirect_to pots_path, notice: "Pot created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @pot.update(pot_params)
      redirect_to pot_path(@pot), notice: "Pot updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pot.destroy
    redirect_to pots_path, notice: "Pot deleted."
  end

  def add_money
    amount_cents = money_to_cents(params[:amount])
    @pot.add_money!(amount_cents)
    redirect_to pots_path, notice: "Money added to #{@pot.name}."
  rescue ArgumentError => e
      redirect_to pots_path, alert: e.message
  end

  def withdraw_money
    amount_cents = money_to_cents(params[:amount])
    @pot.withdraw_money!(amount_cents)
    redirect_to pots_path, notice: "Money withdrawn from #{@pot.name}."
  rescue ArgumentError => e
      redirect_to pots_path, alert: e.message
  end

  private

  def set_pot
    @pot = current_user.pots.find(params[:id])
  end

  def pot_params
    params.require(:pot).permit(:name, :target, :saved)
  end

  def money_to_cents(value)
    cleaned = value.to_s.delete(",").strip
    raise ArgumentError, "Amount is required" if cleaned.blank?

    cents = (BigDecimal(cleaned) * 100).to_i
    raise ArgumentError, "Amount must be positive" if cents <= 0
    cents
  end
end
