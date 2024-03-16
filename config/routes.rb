Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "/", to: "indice#index"
  root to: 'indice#index'
  get "/habitaciones", to: "bedrooms#index"
  get "/habitaciones/:id", to: "bedrooms#show", as: :bedroom
  get "/reservas", to: "reservations#index"
  get "/reservas/new", to: "reservations#new", as: "new_reservation"  # Ruta para mostrar el formulario de creación de reserva
  post "/reservas", to: "reservations#create", as: "create_reservation"  # Ruta para crear una nueva reserva
  get "/pagos", to: "pays#index"
  resources :reservations, only: [:new, :create, :index] # Limita las rutas a new, create e index
  resources :residents # Mueve esta línea fuera del bloque de category_bedrooms
  resources :category_bedrooms do
    # Mueve las rutas de residents fuera de este bloque
  end
end
