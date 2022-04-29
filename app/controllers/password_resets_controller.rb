class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    PasswordMailer.with(user: @user).reset.deliver_now if @user.present?

    redirect_to root_path, notice: 'if account exists... reset email'
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to sign_in_path, alert: 'Token has expired'
  end

  def update
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
    if user.update(password_params)
      redirect_to sign_in_path, notice: 'Password changed'
    else
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
