require 'rails_helper'

feature 'Admin manages product categories' do
  describe 'loged' do
    scenario 'and must be signed in' do
      pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')

      visit product_category_path(pc)

      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe 'visit' do
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

  describe 'create' do
    scenario 'successfully' do
      user = User.create!(email: 'user@email.com', password: '123456')
      login_as user, scope: :user

      visit root_path
      click_on 'Categorias de produto'
      click_on 'Criar categoria'
      fill_in 'Nome', with: 'Smartphones'
      fill_in 'Código', with: 'SMARTPH'
      click_on 'Criar Categoria'

      expect(current_path).to eq(product_category_path(ProductCategory.last))
      expect(page).to have_content('Categoria criada com sucesso')
      expect(page).to have_content('Smartphones')
      expect(page).to have_content('SMARTPH')
      expect(page).to have_link('Voltar', href: product_categories_path)
    end

    scenario 'and attributes cannot be blank' do
      user = User.create!(email: 'user@email.com', password: '123456')
      login_as user, scope: :user

      visit root_path
      click_on 'Categorias de produto'
      click_on 'Criar categoria'
      fill_in 'Nome', with: ''
      fill_in 'Código', with: ''
      click_on 'Criar Categoria'

      expect(page).to have_content('Não foi possível criar a categoria')
      expect(page).to have_content('Nome não pode ficar em branco')
      expect(page).to have_content('Código não pode ficar em branco')
    end

    scenario 'and code must be unique' do
      user = User.create!(email: 'user@email.com', password: '123456')
      login_as user, scope: :user
      ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')

      visit root_path
      click_on 'Categorias de produto'
      click_on 'Criar categoria'
      fill_in 'Código', with: 'SMARTPH'
      click_on 'Criar Categoria'

      expect(page).to have_content('Código já está em uso')
    end
  end

  describe 'update' do
    scenario 'successfully' do
      user = User.create!(email: 'user@email.com', password: '123456')
      login_as user, scope: :user

      ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')

      visit root_path
      click_on 'Categorias de produto'
      click_on 'Smartphones'
      click_on 'Editar categoria'
      fill_in 'Nome', with: 'Celulares'
      click_on 'Atualizar Categoria'

      expect(current_path).to eq(product_category_path(ProductCategory.last))
      expect(page).to have_content('Categoria atualizada com sucesso')
      expect(page).to have_content('Celulares')
      expect(page).to have_content('SMARTPH')
      expect(page).to have_link('Voltar', href: product_categories_path)
    end

    scenario 'and attributes cannot be blank' do
      user = User.create!(email: 'user@email.com', password: '123456')
      login_as user, scope: :user

      ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')

      visit root_path
      click_on 'Categorias de produto'
      click_on 'Smartphones'
      click_on 'Editar categoria'
      fill_in 'Nome', with: ''
      fill_in 'Código', with: ''
      click_on 'Atualizar Categoria'

      expect(page).to have_content('Não foi possível atualizar a categoria')
      expect(page).to have_content('Nome não pode ficar em branco')
      expect(page).to have_content('Código não pode ficar em branco')
    end

    scenario 'and code must be unique' do
      user = User.create!(email: 'user@email.com', password: '123456')
      login_as user, scope: :user

      ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
      ProductCategory.create!(name: 'Celulares', code: 'CELLPH')

      visit root_path
      click_on 'Categorias de produto'
      click_on 'Celulares'
      click_on 'Editar categoria'
      fill_in 'Código', with: 'SMARTPH'
      click_on 'Atualizar Categoria'

      expect(page).to have_content('Código já está em uso')
    end
  end
end
