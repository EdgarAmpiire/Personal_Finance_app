class SessionsController < ApplicationController
  def new
    redirect_to dashboard_path, notice: "You're already signed in!" if signed_in?
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user&.authenticate(params[:password].to_s)
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "You're Signed in!"
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to sign_in_path, notice: "You're Signed out."
  end
end
