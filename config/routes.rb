Rails.application.routes.draw do

  resources :users
  root to: 'static_pages#home'
  get  '/static_pages/secret/', to: 'static_pages#secret', as: 'secret'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
