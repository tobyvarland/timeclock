json.array! @users do |user|
  json.employee_number user.employee_number
  json.name user.name
  json.punches user.punches.current_week.chronological do |punch|
    json.type punch.punch_type
    json.timestamp punch.punch_at
  end
end