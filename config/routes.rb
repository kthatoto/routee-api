Rails.application.routes.draw do
  get :home, to: 'home#index'
  post :routines, to: 'routines#create'
end
