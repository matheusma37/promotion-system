require 'rails_helper'

feature 'Admin generates coupons' do
  scenario 'and must be signed in' do
    user = User.create!(email: 'user@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'of a promotion' do
    creator = User.create!(email: 'creator@email.com', password: '123456')
    approver = User.create!(email: 'approver@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: creator)
    login_as creator, scope: :user

    promotion.approve!(approver)
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Gerar cupons'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('Cupons gerados com sucesso')
    expect(page).to have_content('NATAL10-0001')
    expect(page).to have_content('NATAL10-0002')
    expect(page).to have_content('NATAL10-0100')
    expect(page).not_to have_content('NATAL10-0101')
  end

  scenario 'hide button if all coupons were generated' do
    creator = User.create!(email: 'creator@email.com', password: '123456')
    approver = User.create!(email: 'approver@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: creator)
    login_as creator, scope: :user

    promotion.approve!(approver)
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Gerar cupons'

    promotion.reload
    expect(promotion.coupons.size).to eq(promotion.coupon_quantity)
    expect(page).not_to have_link('Gerar cupons',
                                  href: generate_coupons_promotion_path(promotion))
  end
end
