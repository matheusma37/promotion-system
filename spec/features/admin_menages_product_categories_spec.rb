require 'rails_helper'

feature 'Admin manages product categories' do
  scenario 'and must be signed in' do
    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')

    visit product_category_path(pc)

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'successfully' do
    user = User.create!(email: 'user@email.com', password: '123456')
    login_as user, scope: :user

    ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    ProductCategory.create!(name: 'Monitores', code: 'Display')
    ProductCategory.create!(name: 'Jogos', code: 'GAME')
    ProductCategory.create!(name: 'Webcams', code: 'WEBCAM')

    visit root_path
    click_on 'Categorias de produto'

    expect(current_path).to eq(product_categories_path)
    expect(page).to have_content('Smartphones')
    expect(page).to have_content('Monitores')
    expect(page).to have_content('Jogos')
    expect(page).to have_content('Webcams')
    expect(page).to have_link('Voltar', href: root_path)
  end

  scenario 'and view details' do
    user = User.create!(email: 'user@email.com', password: '123456')
    login_as user, scope: :user

    pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    ProductCategory.create!(name: 'Monitores', code: 'Display')
    ProductCategory.create!(name: 'Jogos', code: 'GAME')
    ProductCategory.create!(name: 'Webcams', code: 'WEBCAM')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'Smartphones'

    expect(current_path).to eq(product_category_path(pc))
    expect(page).to have_content('Smartphones')
    expect(page).to have_content('SMARTPH')
    expect(page).to have_link('Voltar', href: product_categories_path)
  end

  scenario 'and no product categories are created' do
    user = User.create!(email: 'user@email.com', password: '123456')
    login_as user, scope: :user

    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_content('Nenhuma categoria cadastrada')
  end

  scenario 'and return to home page' do
    user = User.create!(email: 'user@email.com', password: '123456')
    login_as user, scope: :user

    ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and return to product categories page' do
    user = User.create!(email: 'user@email.com', password: '123456')
    login_as user, scope: :user

    ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')

    visit root_path
    click_on 'Categorias de produto'
    click_on 'Smartphones'
    click_on 'Voltar'

    expect(current_path).to eq product_categories_path
  end
end
