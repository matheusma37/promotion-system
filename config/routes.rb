Rails.application.routes.draw do
  get '/', to: 'home#index'
  root 'home#index'

  resources :promotions, only: %i[index show new create edit update destroy] do
    post 'generate_coupons', on: :member
  end
end
