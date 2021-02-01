Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'home#index'
  root 'home#index'

  resources :promotions, only: %i[index show new create edit update]
end
