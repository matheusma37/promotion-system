require 'rails_helper'

feature 'Visitor visit home page' do
  scenario 'and must be signed in' do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user, product_categories: [pc])

    visit promotion_path(promotion)

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'successfully' do
    visit root_path

    expect(page).to have_content('Promotion System')
    expect(page).to have_content('Boas vindas ao sistema de gestão de '\
                                 'promoções')
  end
end
