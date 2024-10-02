Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  if Rails.env.production? || Rails.env.staging?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == ENV["SIDEKIQ_USER"] && password == ENV["SIDEKIQ_PASSWORD"]
    end
  end

  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      resources :bills, only: [ :create, :index ]
      resources :clients, only: [ :create ]
      resources :webhooks, only: [ :create, :index ]
    end
  end
end
