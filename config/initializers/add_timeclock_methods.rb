class Time

  # Rounds given time to clock-in time.
  def to_clock_in_time
    Time.at((self.change(:sec => 0).to_f / 15.minutes).ceil * 15.minutes).utc
  end

  # Rounds given time to clock-out time.
  def to_clock_out_time
    Time.at((self.change(:sec => 0).to_f / 15.minutes).floor * 15.minutes).utc
  end

end

class DateTime

  # Rounds given time to clock-in time.
  def to_clock_in_time
    Time.at((self.change(:sec => 0).to_f / 15.minutes).ceil * 15.minutes).utc
  end

  # Rounds given time to clock-out time.
  def to_clock_out_time
    Time.at((self.change(:sec => 0).to_f / 15.minutes).floor * 15.minutes).utc
  end

end