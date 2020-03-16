class PhoneController < ApplicationController

  # Set layout for all controller actions.
  layout  "phone"

  # Reference current user before each action.
  before_action :phone_authorized,
                except: :now

  # Index action. Shows available actions.
  def index
    @new_punch = phone_current_user.punches.new(punch_at: Time.current)
  end

  # Time card page. Shows current week time card.
  def timecard
    @punches = phone_current_user.punches.current_week.reverse_chronological
  end

  # Now page. Shows all clocked in users.
  def now
    @users = User.on_the_clock.by_number
  end

end