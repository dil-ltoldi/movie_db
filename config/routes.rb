Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "movies#index"
  get '/search', to: 'movies#search'
end
