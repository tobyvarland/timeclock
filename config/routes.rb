Rails.application.routes.draw do

  resources :punches
  resources :users
  
  get   "ipad",                 to: "ipad#index"
  get   "ipad/card",            to: "ipad#timecard"
  get   "ipad/now",             to: "ipad#now"
  get   "ipad/employee_number", to: "mobile_sessions#number"
  post  "ipad/employee_number", to: "mobile_sessions#validate_number"
  get   "ipad/pin",             to: "mobile_sessions#pin"
  post  "ipad/pin",             to: "mobile_sessions#validate_pin"
  post  "ipad/logout",          to: "mobile_sessions#destroy"
  get   "ipad/logout",          to: "mobile_sessions#destroy"

end