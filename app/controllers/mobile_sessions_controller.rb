class MobileSessionsController < ApplicationController

  # Set layout for all controller actions.
  layout  "ipad"

  # Displays form for entering employee number.
  def number
  end

  # Validates employee number.
  def validate_number
    user = User.find_by_employee_number(params[:employee_number])
    if user.present?
      session[:login_user] = params[:employee_number]
      redirect_to(action: :pin)
    else
      render(:number)
    end
  end

  # Displays form for entering pin.
  def pin
    redirect_to(action: :number) unless session[:login_user].present?
    @employee_number = session[:login_user]
  end

  # Validates pin.
  def validate_pin
    user = User.find_by_employee_number(params[:employee_number])
    if user && user.pin == params[:pin]
      session[:mobile_user_id] = user.id
      redirect_to(ipad_url)
    else
      render(:pin)
    end
  end

  # Logs user out.
  def destroy
    session.delete(:login_user)
    session.delete(:mobile_user_id)
    redirect_to(ipad_url)
  end

end