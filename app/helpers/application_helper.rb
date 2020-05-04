module ApplicationHelper

  def required_field_indicator
    "<sup class=\"text-danger\"><small><i class=\"fas fa-asterisk\"></i></small></sup>"
  end

  def right_now_bg(status)
    case status
    when "on_break"
      return "on-break"
    when "remote_in"
      return "remote-in"
    else
      return "clocked-in"
    end
  end

  def status_label(status)
    case status
    when "on_break"
      return "On Break"
    when "remote_in"
      return "Remote"
    else
      return ""
    end
  end

end