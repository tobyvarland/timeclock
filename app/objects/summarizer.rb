# Class to calculate and summarize user punches for a given period.
class Summarizer

  # Define attribute accessors.
  attr_reader :punches
  attr_reader :error
  attr_reader :error_msg
  attr_reader :total_hours
  attr_reader :first_shift_reg
  attr_reader :first_shift_ot
  attr_reader :other_shift_reg
  attr_reader :other_shift_ot
  attr_reader :shifts
  attr_reader :remote

  # Constructor. Accepts collection of punches for a given user in a given period.
  def initialize(punches, use_rounding = true)

    # Save collection of punches and options.
    @punches = punches
    @use_rounding = use_rounding

    # Calculate stats for punches.
    self.calc_stats

  end

protected

  # Calculates stats.
  def calc_stats

    # Initialize stats.
    @error = false
    @error_msg = nil
    @total_hours = 0
    @first_shift_reg = 0
    @first_shift_ot = 0
    @other_shift_reg = 0
    @other_shift_ot = 0
    @remote = 0
    @shifts = []
    status = :out
    shift_start = nil
    shift_end = nil
    current_shift_punches = nil
    in_overtime = false
    break_start = nil
    break_end = nil
    break_length = 0

    # If no punches, store error.
    if @punches.blank? || @punches.length == 0
      @error = true
      @error_msg = "Employee has no records in period."
      return
    end

    # Loop through punches to calculate time.
    @punches.each do |p|

      # Skip notes.
      if p.punch_type == "notes"
        @shifts << {
          punches: [p],
          first_shift_hours: 0,
          other_shift_hours: 0,
          remote_hours: 0,
          total_hours: 0,
          break_length: 0,
        }
        next
      end

      # If status is out, only valid punch is start_work.
      if status == :out

        # Error if invalid punch type.
        if !["start_work", "remote_start"].include? p.punch_type
          @error = true
          @error_msg = "Found record other than Start Work or Remote Start when clocked out."
          break
        end

        # Change status and store shift start time.
        status = p.punch_type == "start_work" ? :in : :remote_in
        shift_start = p.punch_at
        current_shift_punches = [p]

      # If status is remote in, may have remote end only.
      elsif status == :remote_in

        # Error if invalid punch type.
        if p.punch_type != "remote_end"
          @error = true
          @error_msg = "Found record other than Remote End when clocked in remotely."
          break
        end

        # Calculate hours and end shift.
        current_shift_punches << p
        shift_end = p.punch_at
        shift_hours = self.calculate_shift_hours(shift_start, shift_end, true)
        shift_first_shift_hours = 0
        shift_other_shift_hours = 0
        shift_remote_hours = 0
        shift_total_hours = 0
        shift_hours.each do |s_h|
          if s_h[:shift] == "remote"
            shift_remote_hours = s_h[:hours]
            @remote += s_h[:hours]
          else
            if in_overtime
              if s_h[:shift] != 1
                @other_shift_ot += s_h[:hours]
              else
                @first_shift_ot += s_h[:hours]
              end
            else
              if @total_hours + s_h[:hours] > 40
                temp_reg = 40 - @total_hours
                temp_ot = s_h[:hours] - temp_reg
                if s_h[:shift] != 1
                  @other_shift_reg += temp_reg
                  @other_shift_ot += temp_ot
                else
                  @first_shift_reg += temp_reg
                  @first_shift_ot += temp_ot
                end
                in_overtime = true
              else
                if s_h[:shift] != 1
                  @other_shift_reg += s_h[:hours]
                else
                  @first_shift_reg += s_h[:hours]
                end
              end
            end
          end
          @total_hours += s_h[:hours]
          shift_total_hours += s_h[:hours]
          unless s_h[:shift] == "remote"
            if s_h[:shift] != 1
              shift_other_shift_hours += s_h[:hours]
            else
              shift_first_shift_hours += s_h[:hours]
            end
          end
        end
        @shifts << {
          punches: current_shift_punches,
          first_shift_hours: shift_first_shift_hours,
          other_shift_hours: shift_other_shift_hours,
          remote_hours: shift_remote_hours,
          total_hours: shift_total_hours,
          break_length: 0,
        }
        status = :out
        shift_start = nil
        shift_end = nil
        current_shift_punches = nil
        break_start = nil
        break_end = nil
        break_length = 0

      # If status is in, may have start break or end work.
      elsif status == :in

        # Error if invalid punch type.
        if !["start_break", "end_work"].include? p.punch_type
          @error = true
          @error_msg = "Found record other than Start Break or End Work when clocked in."
          break
        end

        # Change status and close out shift if necessary.
        current_shift_punches << p
        if p.punch_type == "start_break"
          status = :break
          break_start = p.punch_at
        else
          shift_end = p.punch_at
          shift_hours = self.calculate_shift_hours(shift_start, shift_end)
          shift_first_shift_hours = 0
          shift_other_shift_hours = 0
          shift_remote_hours = 0
          shift_total_hours = 0
          shift_hours.each do |s_h|
            if in_overtime
              if s_h[:shift] != 1
                @other_shift_ot += s_h[:hours]
              else
                @first_shift_ot += s_h[:hours]
              end
            else
              if @total_hours + s_h[:hours] > 40
                temp_reg = 40 - @total_hours
                temp_ot = s_h[:hours] - temp_reg
                if s_h[:shift] != 1
                  @other_shift_reg += temp_reg
                  @other_shift_ot += temp_ot
                else
                  @first_shift_reg += temp_reg
                  @first_shift_ot += temp_ot
                end
                in_overtime = true
              else
                if s_h[:shift] != 1
                  @other_shift_reg += s_h[:hours]
                else
                  @first_shift_reg += s_h[:hours]
                end
              end
            end
            @total_hours += s_h[:hours]
            shift_total_hours += s_h[:hours]
            if s_h[:shift] != 1
              shift_other_shift_hours += s_h[:hours]
            else
              shift_first_shift_hours += s_h[:hours]
            end
          end
          @shifts << {
            punches: current_shift_punches,
            first_shift_hours: shift_first_shift_hours,
            other_shift_hours: shift_other_shift_hours,
            remote_hours: shift_remote_hours,
            total_hours: shift_total_hours,
            break_length: break_length,
          }
          status = :out
          shift_start = nil
          shift_end = nil
          current_shift_punches = nil
          break_start = nil
          break_end = nil
          break_length = 0
        end

      # If status is break, only valid punch type is end_break.
      elsif status == :break

        # Error if invalid punch type.
        if p.punch_type != "end_break"
          @error = true
          @error_msg = "Found record other than End Break when on break."
          break
        end

        # Change status and store shift start time.
        break_end = p.punch_at
        break_length = (break_end - break_start) / 60.0
        current_shift_punches << p
        status = :in

      end

    end

    # If not clocked out and end of period, raise error.
    if status != :out
      @error = true
      @error_msg = "Employee not clocked out @ end of period."
    end

  end

  # Calculates hours for a given shift.
  def calculate_shift_hours(shift_start, shift_end, is_remote = false)
    hours_by_shift = []
    if is_remote
      rounded_start = Time.at(shift_start.change(:sec => 0)).in_time_zone
      rounded_end = Time.at(shift_end.change(:sec => 0)).in_time_zone
      total_hours = [((rounded_end - rounded_start) / 1.hour), 0].max
      rounded_total_hours = (total_hours * 4).round / 4.0
      rounded_total_hours += 0.25 if rounded_total_hours < total_hours
      hours_by_shift << { shift: "remote", hours: rounded_total_hours }
      return hours_by_shift
    end
    rounded_start = @use_rounding ? VarlandTimeclock.clock_in_time(shift_start) : shift_start
    rounded_end = @use_rounding ? VarlandTimeclock.clock_out_time(shift_end) : shift_end
    case rounded_start.hour
    when 0..6
      shift = 3
    when 7..14
      shift = 1
    when 15..22
      shift = 2
    when 23
      shift = 3
    end
    current_start = rounded_start
    next_delineation = nil
    until next_delineation == rounded_end
      next_delineation = [rounded_end, self.calculate_end_of_shift(current_start)].min
      current_shift_hours = [((next_delineation - current_start) / 1.hour), 0].max.round(2)
      hours_by_shift << { shift: shift, hours: current_shift_hours }
      current_start = next_delineation
      shift += 1
      shift = 1 if shift > 3
    end
    return hours_by_shift
  end

  # Calculates end of shift for given time.
  def calculate_end_of_shift(timestamp)
    end_of_hour = timestamp.end_of_hour
    case end_of_hour.hour
    when 0..6
      target = 7
    when 7..14
      target = 15
    when 15..22
      target = 23
    when 23
      target = 7
    end
    advanced = end_of_hour.advance(seconds: 1)
    until advanced.hour == target
      advanced = advanced.advance(hours: 1)
    end
    return advanced
  end

end