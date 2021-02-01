require 'rails_helper'

feature 'Admin edits a promotion' do
  scenario 'from index page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'

    expect(page).to have_link('Editar promoção',
                              href: edit_promotion_path(Promotion.last))
  end

  scenario 'successfully' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar promoção'

    fill_in 'Nome', with: 'Natal 10'
    fill_in 'Descrição', with: 'Promoção de Natal'
    fill_in 'Código', with: 'NATAL10'
    fill_in 'Desconto', with: '10'
    fill_in 'Quantidade de cupons', with: '100'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Atualizar promoção'

    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content('Natal 10')
    expect(page).to have_content('Promoção de Natal')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('NATAL10')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('100')
    expect(page).to have_link('Voltar')
  end

  scenario 'and attributes cannot be blank' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar promoção'

    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Atualizar promoção'

    expect(page).to have_content('Não foi possível editar a promoção')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Desconto não pode ficar em branco')
    expect(page).to have_content('Código não pode ficar em branco')
    expect(page).to have_content('Data de término não pode ficar em branco')
    expect(page).to have_content('Quantidade de cupons não pode ficar em branco')
  end

  scenario 'and code must be unique' do
    Promotion.create!(name: 'Natal 10', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Natal 2021', description: 'Promoção de Natal',
                      code: 'NATAL15', discount_rate: 15, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Natal 2021'
    click_on 'Editar promoção'

    fill_in 'Código', with: 'NATAL10'
    click_on 'Atualizar promoção'

    expect(page).to have_content('Código já está em uso')
  end
end
