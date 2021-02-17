Rails.application.routes.draw do
  get '/', to: 'home#index'
  root 'home#index'

  devise_for :users

  resources :promotions, only: %i[index show new create edit update destroy] do
    member do
      post 'generate_coupons'
      post 'approve'
    end
  end

  # resources :coupons, only: [] do
  #   post 'inactivate', on: :member
  # end
  post '/coupons/:id/inactivate', to: 'coupons#inactivate', as: :inactivate_coupon

  resources :product_categories, only: %i[index show]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :coupons, only: [:show]
    end
  end
end
