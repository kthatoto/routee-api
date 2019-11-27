Rails.application.routes.draw do
  get :home, to: 'home#index'
  resources :routines, only: [:create] do
    get   :status,          on: :collection
    patch :toggle_achieved, on: :member
    patch :decrement,       on: :member
  end
end
