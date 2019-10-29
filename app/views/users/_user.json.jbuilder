json.extract! user, :id, :employee_number, :name, :pin, :created_at, :updated_at
json.url user_url(user, format: :json)
