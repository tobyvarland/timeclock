class SessionsController < ApplicationController

  # Set layout for all controller actions.
  layout  "login"

  def new
  end

  def create
    @user = User.find_by_username(params[:username])
    if @user && @user.ibm_authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to(root_url)
    else
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to(root_url)
  end

end