Rails.application.routes.draw do
  # rubies se llama el hotel fictisio
  get "up" => "rails/health#show", as: :rails_health_check
  get "/", to: "indice#index"
  root to: 'indice#index'
  get "/habitaciones", to: "bedrooms#index"
  get "/habitaciones/:id", to: "bedrooms#show", as: :bedroom
  get "/reservas", to: "reservations#index"
  get "/reservas/new", to: 'reservations#new', as: :new_reservation
  post "/reservas", to: 'reservations#create' # Ruta para crear una nueva reserva
  resources :residents # Mueve esta línea fuera del bloque de category_bedrooms
  resources :reservations

  resources :category_bedrooms do
    # Mueve las rutas de residents fuera de este bloque
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
