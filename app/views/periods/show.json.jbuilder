json.period_ending_date @period.ends_on
json.employees @all_users do |user|
  summary = Summarizer.new(user.punches.in_period(@period.id).chronological, user.employee_number < 1000)
  json.employee_number user.employee_number
  json.name user.name
  json.error summary.error
  if summary.error
    json.error_msg summary.error_msg
  else
    json.total_hours summary.total_hours
    json.first_shift_regular summary.first_shift_reg
    json.first_shift_overtime summary.first_shift_ot
    json.other_shift_regular summary.other_shift_reg
    json.other_shift_overtime summary.other_shift_ot
    json.shifts summary.shifts do |shift|
      json.total_hours shift[:total_hours]
      json.first_shift_hours shift[:first_shift_hours]
      json.other_shift_hours shift[:other_shift_hours]
      json.punches shift[:punches] do |punch|
        json.type punch.punch_type
        json.timestamp punch.punch_at
        unless punch.edited_by_id.blank?
          json.edited true
          json.edited_by punch.editor.name
          json.edited_at punch.edited_at
          json.reason punch.reason_code.code
          json.notes punch.notes
        end
      end
    end
  end
end