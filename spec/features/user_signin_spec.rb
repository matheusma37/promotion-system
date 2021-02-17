require 'rails_helper'

feature 'User sign in' do
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

    visit root_path

    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail',	with: user.email
      fill_in 'Senha',	with: user.password
      click_on 'Entrar'
    end

    expect(page).to have_content(user.email)
    expect(page).to have_content('Login efetuado com sucesso.')
    expect(page).to have_link('Sair')
    expect(page).not_to have_link('Entrar')
  end

  scenario 'and logout' do
    user = User.create!(email: 'user@email.com', password: '123456')

    visit root_path

    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail',	with: user.email
      fill_in 'Senha',	with: user.password
      click_on 'Entrar'
    end

    click_on 'Sair'

    expect(page).not_to have_content(user.email)
    expect(page).not_to have_link('Sair')
    expect(page).to have_link('Entrar')
  end

  scenario 'sign up' do
    visit root_path

    click_on 'Entrar'
    click_on 'Inscrever-se'
    within('form') do
      fill_in 'E-mail',	with: 'user@email.com'
      fill_in 'Senha',	with: '123456'
      fill_in 'Confirme sua senha',	with: '123456'
      click_on 'Inscrever-se'
    end

    expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso.')
    within('nav') do
      expect(page).to have_content('user@email.com')
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Entrar')
    end
  end
end
