class Calculator

  def self.calculate_shift_hours(shift_start, shift_end = nil, use_rounding = true)
    if shift_end.blank?
      shift_end = DateTime.current.in_time_zone
    end
    rounded_start = use_rounding ? VarlandTimeclock.clock_in_time(shift_start) : Time.at(shift_start.change(:sec => 0)).in_time_zone
    rounded_end = use_rounding ? VarlandTimeclock.clock_out_time(shift_end) : Time.at(shift_end.change(:sec => 0)).in_time_zone
    return [((rounded_end - rounded_start) / 1.hour), 0].max
  end

  def self.calculate_hours(punches)
    
    # Initialize hours & status @ beginning of period.
    hours = 0
    hours_so_far = 0
    status = :out
    error = false
    error_msg = nil
    shift_start = nil
    shift_end = nil
    as_of = nil
    shifts = []

    # Loop through punches and calculate time.
    punches.each do |p|

      # Ignore punches that are only notes.
      next if p.punch_type == "notes"

      # Look for start work if status is currently out. Store shift starting time and update status.
      if status == :out

        # Flag error if invalid punch type found.
        if !["start_work", "remote_start"].include? p.punch_type
          @error = true
          @error_msg = "Found non start_work or remote_start when clocked out."
          break
        end

        # Change status and store shift start time.
        status = p.punch_type == "start_work" ? :in : :remote_in
        shift_start = p.punch_at
    
      elsif status == :remote_in

        # Flag error if invalid punch type found.
        if p.punch_type != "remote_end"
          error = true
          error_msg = "Found non remote_end when clocked in remotely."
          break
        end

        # Change status and update shift end time if necessary.
        status = :out
        shift_end = p.punch_at
        shift_hours = self.calculate_shift_hours(shift_start, shift_end, false)
        rounded_shift_hours = (shift_hours * 10).round / 10.0
        rounded_shift_hours += 0.1 if rounded_shift_hours < shift_hours
        shift_hours = rounded_shift_hours
        hours += shift_hours
        shifts << { remote: true, start: shift_start, end: shift_end, hours: shift_hours, current: false }
    
      elsif status == :in

        # Flag error if invalid punch type found.
        if !["start_break", "end_work"].include? p.punch_type
          error = true
          error_msg = "Found non start_break/end_work when clocked in."
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
          shifts << { remote: false, start: shift_start, end: shift_end, hours: shift_hours, current: false }
        end

      elsif status == :break

        # Flag error if invalid punch type found.
        if p.punch_type != "end_break"
          error = true
          error_msg = "Found non end_break when on break."
          break
        end

        # Change status
        status = :in
    
      end

    end

    if status != :out
      is_remote = (status == :remote_in)
      as_of = DateTime.current
      hours_so_far = self.calculate_shift_hours(shift_start, as_of, !is_remote)
      if is_remote
        rounded_hours_so_far = (hours_so_far * 10).round / 10.0
        rounded_hours_so_far += 0.1 if rounded_hours_so_far < hours_so_far
        hours_so_far = rounded_hours_so_far
      end
      shifts << { remote: is_remote, start: shift_start, end: as_of, hours: hours_so_far, current: true }
    end

    # Return hours and error status.
    return OpenStruct.new({ hours: hours, hours_so_far: hours_so_far, as_of: as_of, shifts: shifts, error: error, error_msg: error_msg })

  end

end