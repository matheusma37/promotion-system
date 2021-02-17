require 'rails_helper'

feature 'Admin registers a promotion' do
  scenario 'must be signed in' do
    visit root_path
    click_on 'Promoções'

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'from index page' do
    user = User.create!(email: 'user@email.com', password: '123456')

    login_as(user)
    visit root_path
    click_on 'Promoções'

    expect(page).to have_link('Registrar uma promoção',
                              href: new_promotion_path)
  end

  scenario 'successfully' do
    user = User.create!(email: 'user@email.com', password: '123456')
    ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')

    login_as(user)
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    check 'Smartphones'
    click_on 'Criar promoção'

    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('CYBER15')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('90')
    expect(page).to have_content('Cadastrada por: user@email.com')
    expect(page).to have_link('Voltar')
  end

  scenario 'and choose many product categories' do
    ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    ProductCategory.create!(name: 'Monitores', code: 'Display')
    ProductCategory.create!(name: 'Jogos', code: 'GAME')
    ProductCategory.create!(name: 'Webcams', code: 'WEBCAM')

    user = User.create!(email: 'user@email.com', password: '123456')

    login_as(user)
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    check 'Smartphones'
    check 'Jogos'
    check 'Monitores'
    click_on 'Criar promoção'

    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content('Smartphones')
    expect(page).to have_content('Jogos')
    expect(page).to have_content('Monitores')
    expect(page).not_to have_content('Webcams')
  end
end
