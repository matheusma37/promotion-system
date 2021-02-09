require 'rails_helper'

feature 'User sign in' do
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

  # TODO: Implementar essa feature
  scenario 'sign up' do
    pending
    visit root_path

    click_on 'Entrar'
    click_on 'Inscrever-se'
    within('form') do
      fill_in 'E-mail',	with: 'user@email.com'
      fill_in 'Senha',	with: '123456'
      fill_in 'Confirme sua senha',	with: '123456'
      click_on 'Inscrever-se'
    end

    within('nav') do
      expect(page).to have_content(user.email)
      expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso.')
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Entrar')
    end
  end
end
