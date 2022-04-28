class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    PasswordMailer.with(user: @user).reset.deliver_now if @user.present?

    redirect_to root_path, notice: 'if account exists... reset email'
  end

  def edit
    @user = User.find_signed(params[:token], purpose: 'password_reset')

  end
end
