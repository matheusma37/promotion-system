require 'rails_helper'

describe 'Coupon management' do
  context 'GET coupon' do
    it 'should render coupon details' do
      user = User.create!(email: 'user@email.com', password: '123456')
      approver = User.create!(email: 'approver@email.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)
      promotion.approve!(approver)
      promotion.generate_coupons!
      coupon = promotion.coupons.last

      get "/api/v1/coupons/#{coupon.code}"
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json_response[:status]).to eq('active')
      expect(json_response[:code]).to eq(coupon.code)
      expect(json_response[:promotion][:discount_rate]).to eq('10.0')
    end

    it 'should return 404 if coupon code does not exist' do
      get '/api/v1/coupons/test'
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json_response[:msg]).to eq('coupon not found')
    end
  end

  context 'POST coupon usage' do
    # TODO: implementar essa feature
    it 'should generate burn a coupon' do
      pending
      user = User.create!(email: 'user@email.com', password: '123456')
      approver = User.create!(email: 'approver@email.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)
      promotion.approve!(approver)
      promotion.generate_coupons!
      coupon = promotion.coupons.last

      post "/api/v1/coupons/#{coupon.code}/burn"

      expect(response).to have_http_status(:ok)
      expect(json_response[:msg]).to eq('coupon not found')
    end
  end
end
