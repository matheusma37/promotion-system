require 'rails_helper'

feature 'Admin inactivate coupon' do
  scenario 'successfully' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Inativar'

    expect(page).to have_content("#{coupon.code} (Inativo)")
  end
end