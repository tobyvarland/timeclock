class TimeclockController < ApplicationController

  # Require supervisor privileges for viewing temperature log.
  before_action :authorized_as_supervisor,
                only: [:temperature_log]

  # Reference current user before each action.
  before_action :authorized,
                except: [:now, :temperature_log, :foremen_email]

  # Temperature log page.
  def temperature_log
    @punches = Punch.with_temperature.reverse_chronological
  end

  # Timeclock home page.
  def index
    @punches = current_user.punches.current_week.reverse_chronological
    @current_week_hours = Calculator.calculate_hours(@punches.reverse)
    @last_week_punches = current_user.punches.previous_week.reverse_chronological
    @last_week_hours = Calculator.calculate_hours(@last_week_punches.reverse)
  end

  # Shows currently logged in users.
  def now
    @users = User.on_the_clock.by_number
    @foremen = User.acting_as_foreman
    auto_refresh 20
  end

  # Returns email addresses for current foremen.
  def foremen_email
    @email_addresses = ["vmsforemen@gmail.com"]
  end

end