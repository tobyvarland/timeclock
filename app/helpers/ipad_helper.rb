module IpadHelper

  # Gets contextual cell class for punch type.
  def class_for_punch_type(type)
    case type
    when "start_work"
      return "table-success"
    when "end_work"
      return "table-danger"
    when "start_break", "end_break"
      return "table-warning"
    else
      return ""
    end
  end

end