Rails.application.routes.draw do
  # rubies se llama el hotel fictisio
  get "up" => "rails/health#show", as: :rails_health_check
  get "rubies/", to: "indice#index"
  root to: 'indice#index'
  get "/habitaciones", to: "bedrooms#index"
  get "/habitaciones/:id", to: "bedrooms#show", as: :bedroom
  get "/reservas", to: "reservations#index"
  get "/reservas/new", to: 'reservations#new', as: :new_reservation
  resources :category_bedrooms do
    resources :residents
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
