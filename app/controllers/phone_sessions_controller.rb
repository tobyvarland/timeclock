class PhoneSessionsController < ApplicationController

  # Set layout for all controller actions.
  layout  "phone"

  # Displays form for entering employee number.
  def number
    @users = User.by_number
  end

  # Validates employee number.
  def validate_number
    user = User.find_by_employee_number(params[:employee_number])
    if user.present?
      session[:phone_employee_number] = params[:employee_number]
      redirect_to(action: :pin)
    else
      redirect_to(action: :number)
    end
  end

  # Displays form for entering pin.
  def pin
    redirect_to(action: :number) unless session[:phone_employee_number].present?
    @employee_number = session[:phone_employee_number]
    @user = User.find_by_employee_number(@employee_number)
  end

  # Validates pin.
  def validate_pin
    @user = User.find_by_employee_number(params[:employee_number])
    if @user && @user.pin == params[:pin]
      session[:phone_user_id] = @user.id
      redirect_to(phone_url)
    else
      redirect_to(action: :pin)
    end
  end

  # Logs user out.
  def destroy
    session.delete(:phone_employee_number)
    session.delete(:phone_user_id)
    redirect_to(phone_url)
  end

end