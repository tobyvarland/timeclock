json.array! @users do |user|
  json.employee_number user.employee_number
  json.name user.name
  json.punches user.punches.previous_week.chronological do |punch|
    json.type punch.punch_type
    json.timestamp punch.punch_at
    unless punch.editor.blank?
      json.edited true
      json.editor punch.editor.name
      json.edited_at punch.edited_at
      json.reason punch.reason_code.code
      json.notes punch.notes
    end
  end
end