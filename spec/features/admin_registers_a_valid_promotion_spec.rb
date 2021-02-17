require 'rails_helper'

feature 'Admin registers a valid promotion' do
  scenario 'and must be signed in' do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user, product_categories: [pc])

    visit promotion_path(promotion)

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and attributes cannot be blank' do
    user = User.create!(email: 'user@email.com', password: '123456')
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Criar promoção'

    expect(Promotion.count).to eq 0
    expect(page).to have_content('Não foi possível criar a promoção')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Desconto não pode ficar em branco')
    expect(page).to have_content('Código não pode ficar em branco')
    expect(page).to have_content('Data de término não pode ficar em branco')
    expect(page).to have_content('Quantidade de cupons não pode ficar em branco')
    expect(page).to have_content('Categorias de produto não vinculadas')
  end

  scenario 'and code must be unique' do
    user = User.create!(email: 'user@email.com', password: '123456')
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user, product_categories: [pc])
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar promoção'

    expect(page).to have_content('Código já está em uso')
  end
end
