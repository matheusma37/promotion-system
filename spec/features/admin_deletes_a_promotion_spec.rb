require 'rails_helper'

feature 'Admin deletes a promotion' do
  scenario 'and must be signed in' do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user, product_categories: [pc])

    visit promotion_path(promotion)

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'from index page' do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user, product_categories: [pc])
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).to have_link('Apagar promoção',
                              href: promotion_path(promotion))
  end

  scenario 'and confirm delete', js: true do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user, product_categories: [pc])
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    accept_alert do
      click_link 'Apagar promoção'
    end

    expect(current_path).to eq(promotions_path)
    expect(page).to have_content('Promoção deletada com sucesso')
    expect(Promotion.last).to eq(nil)
  end

  scenario 'and cancel delete', js: true do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user, product_categories: [pc])
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    dismiss_confirm do
      click_link 'Apagar promoção'
    end

    expect(current_path).to eq(promotion_path(promotion))
    expect(Promotion.last).to eq(promotion)
  end
end
