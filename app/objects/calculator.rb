class Calculator

  def self.calculate_shift_hours(shift_start, shift_end = nil)
    if shift_end.blank?
      shift_end = DateTime.now.localtime.strftime("%Y-%m-%dT%H:%M:%S").to_time(:utc)
    end
    rounded_start = shift_start.to_clock_in_time # Time.at((shift_start.change(:sec => 0).to_f / 15.minutes).ceil * 15.minutes).utc
    rounded_end = shift_end.to_clock_out_time # Time.at((shift_end.change(:sec => 0).to_f / 15.minutes).floor * 15.minutes).utc
    return ((rounded_end - rounded_start) / 1.hour)
  end

  def self.calculate_hours(punches)
    
    # Initialize hours & status @ beginning of period.
    hours = 0
    hours_so_far = 0
    status = :out
    error = false
    shift_start = nil
    shift_end = nil
    as_of = nil
    shifts = []

    # Loop through punches and calculate time.
    punches.each do |p|

      # Ignore punches that are only notes.
      next if p.punch_type == :notes

      # Look for start work if status is currently out. Store shift starting time and update status.
      if status == :out

        # Flag error if invalid punch type found.
        if p.punch_type != "start_work"
          error = true
          break
        end

        # Change status and store shift start time.
        status = :in
        shift_start = p.punch_at
    
      elsif status == :in

        # Flag error if invalid punch type found.
        if !["start_break", "end_work"].include? p.punch_type
          error = true
          break
        end

        # Change status and update shift end time if necessary.
        if p.punch_type == "start_break"
          status = :break
        else
          status = :out
          shift_end = p.punch_at
          shift_hours = self.calculate_shift_hours(shift_start, shift_end)
          hours += shift_hours
          shifts << { start: shift_start, end: shift_end, hours: shift_hours, current: false }
        end

      elsif status == :break

        # Flag error if invalid punch type found.
        if p.punch_type != "end_break"
          error = true
          break
        end

        # Change status
        status = :in
    
      end

    end

    if status != :out
      as_of = DateTime.now.localtime.strftime("%Y-%m-%dT%H:%M:%S").to_time(:utc)
      hours_so_far = self.calculate_shift_hours(shift_start, as_of)
      shifts << { start: shift_start, end: as_of, hours: hours_so_far, current: true }
    end

    # Return hours and error status.
    return OpenStruct.new({ hours: hours, hours_so_far: hours_so_far, as_of: as_of, shifts: shifts, error: error })

  end

end