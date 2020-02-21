class VarlandTimeclock

  def self.clock_in_time(timestamp)
    return Time.at((timestamp.change(:sec => 0).to_f / 15.minutes).ceil * 15.minutes).in_time_zone
  end

  def self.clock_out_time(timestamp)
    return Time.at((timestamp.change(:sec => 0).to_f / 15.minutes).floor * 15.minutes).in_time_zone
  end

end