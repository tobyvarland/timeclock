class MobileSessionsController < ApplicationController

  # Set layout for all controller actions.
  layout  "ipad"

  # Displays form for entering employee number.
  def number
    @users = User.by_number
  end

  # Validates employee number.
  def validate_number
    user = User.find_by_employee_number(params[:employee_number])
    if user.present?
      session[:mobile_employee_number] = params[:employee_number]
      redirect_to(action: :pin)
    else
      redirect_to(action: :number)
    end
  end

  # Displays form for entering pin.
  def pin
    redirect_to(action: :number) unless session[:mobile_employee_number].present?
    @employee_number = session[:mobile_employee_number]
    @user = User.find_by_employee_number(@employee_number)
  end

  # Validates pin.
  def validate_pin
    @user = User.find_by_employee_number(params[:employee_number])
    if @user && @user.pin == params[:pin]
      session[:mobile_user_id] = @user.id
      redirect_to(ipad_url)
    else
      redirect_to(action: :pin)
    end
  end

  # Logs user out.
  def destroy
    session.delete(:mobile_employee_number)
    session.delete(:mobile_user_id)
    redirect_to(ipad_url)
  end

end