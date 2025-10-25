Rails.application.routes.draw do
  # Devise routes with OmniAuth callbacks
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # OmniAuth failure route - must be inside devise_scope
  devise_scope :user do
    get "users/auth/failure", to: "users/omniauth_callbacks#failure"
  end

  # OAuth role selection routes
  get "users/oauth/role_selection", to: "users/oauth_role_selection#new", as: :new_users_oauth_role_selection
  post "users/oauth/role_selection", to: "users/oauth_role_selection#create", as: :users_oauth_role_selection

  # Letter opener web for email preview in development
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "home/index"

  # Dashboard routes
  get "athlete_dashboard", to: "dashboards#athlete", as: :athlete_dashboard
  get "trainer_dashboard", to: "dashboards#trainer", as: :trainer_dashboard
  get "admin_dashboard", to: "dashboards#admin", as: :admin_dashboard

  # Debug route for OAuth environment variables
  get "debug/oauth_env", to: "debug#oauth_env"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
