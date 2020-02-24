class SessionsController < ApplicationController

  # Set layout for all controller actions.
  layout  "login"

  def new
  end

  def create
    @user = User.find_by_username(params[:username])
    if @user && @user.ibm_authenticate(params[:password])
      session[:user_id] = @user.id
      if params[:remember_me]
        cookies[:user_id] = { value: @user.id, expires: 1.week.from_now }
      end
      redirect_to(root_url)
    else
      flash.now[:error] = "Login failed. Contact IT if you need help."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    cookies[:user_id] = ""
    redirect_to(root_url)
  end

end