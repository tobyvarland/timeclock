class ApplicationController < ActionController::Base

  # Store current user in change tracking.
  before_action :set_paper_trail_whodunnit

  # Make methods accessible as helpers.
  helper_method :current_user
  helper_method :logged_in?

  # Gets reference to current user.
  def current_user    
    User.find_by(id: session[:mobile_user_id])  
  end

  # Determines if user is logged in.
  def logged_in?
    !current_user.blank?  
  end

  def authorized
    redirect_to(ipad_employee_number_url) unless logged_in?
  end

end