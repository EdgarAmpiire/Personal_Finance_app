class PotsController < ApplicationController
  before_action :require_login
  before_action :set_pot, only: %i[show edit update destroy]

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

  private

  def set_pot
    @pot = current_user.pots.find(params[:id])
  end

  def pot_params
    params.require(:pot).permit(:name, :target, :saved)
  end
end
