Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  # Onboarding flow
  scope :onboarding do
    get  "/",       to: "onboarding#index",   as: :onboarding_root
    post "/upload", to: "onboarding#upload",  as: :onboarding_upload
    get  "/status", to: "onboarding#status",  as: :onboarding_status
    get  "/profile",  to: "onboarding#profile",        as: :onboarding_profile
    patch "/profile", to: "onboarding#update_profile", as: :onboarding_update_profile
    get "/skills",   to: "onboarding#skills",         as: :onboarding_skills
  end

  # Nested resources on candidate profile
  resources :candidate_profiles, only: [] do
    resources :educations, only: %i[create update destroy]
    resources :work_experiences, only: %i[create update destroy]
  end

  resources :candidate_profiles, only: %i[index show]

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "onboarding#index"
end
