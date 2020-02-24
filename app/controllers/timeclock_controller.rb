class TimeclockController < ApplicationController

  # Reference current user before each action.
  before_action :authorized,
                except: :now

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
    auto_refresh 20
  end

end