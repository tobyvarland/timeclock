class TimeclockController < ApplicationController

  # Reference current user before each action.
  before_action :authorized,
                except: :now

  # Timeclock home page.
  def index
    @punches = current_user.punches.current_week.reverse_chronological
    @last_week_punches = current_user.punches.previous_week.reverse_chronological
  end

  # Shows currently logged in users.
  def now
    @users = User.on_the_clock.by_number
  end

end