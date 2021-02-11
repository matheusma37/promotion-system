require 'rails_helper'

feature 'Admin inactivate coupon' do
  scenario 'and must be signed in' do
    user = User.create!(email: 'user@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'successfully' do
    user = User.create!(email: 'user@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    login_as user, scope: :user

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Inativar'

    expect(page).to have_content("#{coupon.code} (Inativo)")
    expect(coupon.reload).to be_inactive
  end

  scenario 'does not show button' do
    user = User.create!(email: 'user@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    login_as user, scope: :user

    inactive_coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion,
                                     status: :inactive)
    active_coupon = Coupon.create!(code: 'NATAL10-0002', promotion: promotion,
                                   status: :active)

    visit promotion_path(promotion)

    expect(page).to have_content('NATAL10-0001 (Inativo)')
    expect(page).to have_content('NATAL10-0002 (Ativo)')

    within("div#coupon-#{active_coupon.id}") do
      expect(page).to have_link('Inativar')
    end

    within("div#coupon-#{inactive_coupon.id}") do
      expect(page).not_to have_link('Inativar')
    end
  end

  scenario 'request an inactivated coupon to inactivate', type: :request do
    user = User.create!(email: 'user@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    login_as user, scope: :user

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion,
                            status: :inactive)

    post "/coupons/#{coupon.id}/inactivate"

    expect(coupon.updated_at).to eq(coupon.reload.updated_at)
  end
end
