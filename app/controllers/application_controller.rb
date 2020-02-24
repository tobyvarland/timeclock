class ApplicationController < ActionController::Base

  # Store current user in change tracking.
  before_action :set_paper_trail_whodunnit

  # Make methods accessible as helpers.
  helper_method :current_user
  helper_method :logged_in?
  helper_method :ipad_current_user
  helper_method :ipad_logged_in?

  # Sets auto refresh value for meta tag.
  def auto_refresh(delay = 30)
    @auto_refresh_delay = delay
    render
  end

  # Gets reference to current user.
  def current_user    
    id = session[:user_id].blank? ? cookies[:user_id] : session[:user_id]
    User.find_by(id: id)  
  end

  # Determines if user is logged in.
  def logged_in?
    !current_user.blank?  
  end

  def authorized
    redirect_to(login_url) unless logged_in?
  end

  def authorized_as_supervisor
    redirect_to(login_url) and return unless logged_in?
    redirect_to(root_url, flash: {error: "You are not authorized to access that page. Please contact IT if you need help."}) unless current_user.access_level_before_type_cast >= 2
  end

  def authorized_as_admin
    redirect_to(login_url) and return unless logged_in?
    redirect_to(root_url, flash: {error: "You are not authorized to access that page. Please contact IT if you need help."}) unless current_user.access_level_before_type_cast == 3
  end

  # Gets reference to current user.
  def ipad_current_user    
    User.find_by(id: session[:mobile_user_id])  
  end

  # Determines if user is logged in.
  def ipad_logged_in?
    !ipad_current_user.blank?  
  end

  def ipad_authorized
    redirect_to(ipad_employee_number_url) unless ipad_logged_in?
  end

  # Persist filters to cookies.
  def filters_to_cookies(filters, global = false)

    filters.each do |f|
      cookie_name = global ? f : "#{params[:controller]}_#{params[:action]}_#{f}"
      if params[:reset]
        cookies[cookie_name] = ""
      else
        if params[f]
          cookies[cookie_name] = { value: params[f], expires: 1.hour.from_now }
        else
          if cookies[cookie_name]
            params[f] = cookies[cookie_name]
          end
        end
      end
    end
  end

end