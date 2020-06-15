class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user&.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      session[:session_token] = @user.session_token
      redirect_back_or(forwarding_url || @user)
    else
      #error message
      flash.now[:danger] = "Invalid email-password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
