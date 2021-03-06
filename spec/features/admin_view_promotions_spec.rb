require 'rails_helper'

feature 'Admin view promotions' do
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
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user, product_categories: [pc])
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user, product_categories: [pc])
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Natal')
    expect(page).to have_content('Promoção de Natal')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
  end

  scenario 'and view details' do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user, product_categories: [pc])
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user, product_categories: [pc])
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('CYBER15')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('90')
  end

  scenario 'and no promotion are created' do
    user = User.create!(email: 'user@email.com', password: '123456')
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end

  scenario 'and return to home page' do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user, product_categories: [pc])
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and return to promotions page' do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user, product_categories: [pc])
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    expect(current_path).to eq promotions_path
  end
end
