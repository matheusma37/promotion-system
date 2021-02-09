Rails.application.routes.draw do
  get '/', to: 'home#index'
  root 'home#index'

  devise_for :users

  resources :promotions, only: %i[index show new create edit update destroy] do
    post 'generate_coupons', on: :member
  end

  # resources :coupons, only: [] do
  #   post 'inactivate', on: :member
  # end
  post '/coupons/:id/inactivate', to: 'coupons#inactivate', as: :inactivate_coupon
end
