Rails.application.routes.draw do

  resources :periods
  resources :reason_codes
  resources :punches
  resources :users

  root  'timeclock#index'
  
  get   "ipad",                 to: "ipad#index"
  get   "ipad/card",            to: "ipad#timecard"
  get   "ipad/now",             to: "ipad#now"
  get   "ipad/employee_number", to: "mobile_sessions#number"
  post  "ipad/employee_number", to: "mobile_sessions#validate_number"
  get   "ipad/pin",             to: "mobile_sessions#pin"
  post  "ipad/pin",             to: "mobile_sessions#validate_pin"
  post  "ipad/logout",          to: "mobile_sessions#destroy"
  get   "ipad/logout",          to: "mobile_sessions#destroy"
  get   "login",                to: "sessions#new"
  post  "login",                to: "sessions#create"
  get   "logout",               to: "sessions#destroy"
  post  "logout",               to: "sessions#destroy"
  get   "now",                  to: "timeclock#now"
  get   "reports/current",      to: "reports#current"
  get   "reports/previous",     to: "reports#previous"

end