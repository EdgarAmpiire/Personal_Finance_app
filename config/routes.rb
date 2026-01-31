Rails.application.routes.draw do
  root "sessions#new"

  get "/sign_up", to: "registrations#new"
  post "/sign_up", to: "registrations#create"

  get "/sign_in", to: "sessions#new"
  post "/sign_in", to: "sessions#create"
  delete "/sign_out", to: "sessions#destroy"

  get "/dashboard", to: "dashboard#show"

  resources :accounts
  resources :transactions
  resources :categories, only: %i[ index new create ]
  resources :budgets, only: [ :index ]
  resources :pots, only: [ :index ]
  resources :recurring_bills, only: [ :index ]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
