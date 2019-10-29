class IpadController < ApplicationController

  # Set layout for all controller actions.
  layout  "ipad"

  # Reference current user before each action.
  before_action :authorized,
                except: :now

  # Index action. Shows available actions.
  def index
    @new_punch = current_user.punches.new(punch_at: Time.now)
  end

  # Time card page. Shows current week time card.
  def timecard
    @punches = current_user.punches.current_week.reverse_chronological
  end

  # Now page. Shows all clocked in users.
  def now
    @users = User.on_the_clock.by_number
  end

end