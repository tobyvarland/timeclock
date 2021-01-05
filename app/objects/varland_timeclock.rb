class VarlandTimeclock

  def self.clock_in_time(timestamp)
    interval = 15.minutes
    interval = 6.minutes if timestamp.year > 2021 || (timestamp.year == 2021 && timestamp.yday >= 3)
    return Time.at((timestamp.change(:sec => 0).to_f / interval).ceil * interval).in_time_zone
  end

  def self.clock_out_time(timestamp)
    interval = 15.minutes
    interval = 6.minutes if timestamp.year > 2021 || (timestamp.year == 2021 && timestamp.yday >= 3)
    return Time.at((timestamp.change(:sec => 0).to_f / interval).floor * interval).in_time_zone
  end

end