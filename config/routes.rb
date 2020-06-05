Rails.application.routes.draw do

  resources :periods
  resources :reason_codes
  resources :punches
  resources :users do
    member do
      post "start_being_foreman"
      post "stop_being_foreman"
    end
  end

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

  get   "phone",                 to: "phone#index"
  get   "phone/card",            to: "phone#timecard"
  get   "phone/now",             to: "phone#now"
  get   "phone/employee_number", to: "phone_sessions#number"
  post  "phone/employee_number", to: "phone_sessions#validate_number"
  get   "phone/pin",             to: "phone_sessions#pin"
  post  "phone/pin",             to: "phone_sessions#validate_pin"
  post  "phone/logout",          to: "phone_sessions#destroy"
  get   "phone/logout",          to: "phone_sessions#destroy"

  get   "login",                to: "sessions#new"
  post  "login",                to: "sessions#create"
  get   "logout",               to: "sessions#destroy"
  post  "logout",               to: "sessions#destroy"
  get   "now",                  to: "timeclock#now"
  get   "tempetature_log",      to: "timeclock#temperature_log"

end