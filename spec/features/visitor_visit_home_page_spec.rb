require 'rails_helper'

feature 'Visitor visit home page' do
  scenario 'successfully' do
    visit root_path

    expect(page).to have_content('Promotion System')
    expect(page).to have_content('Boas vindas ao sistema de gestão de '\
                                 'promoções')
  end

  context 'and search for promotion' do
    scenario 'successfully' do
      user = User.create!(email: 'user@email.com', password: '123456')
      pc = ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: user, product_categories: [pc])
      Promotion.create!(name: 'Natal2020', description: 'Promoção de Natal',
                        code: 'NATAL2020', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: user, product_categories: [pc])
      Promotion.create!(name: 'Black20', description: 'Promoção de Natal',
                        code: 'BLACKF20', discount_rate: 20, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: user, product_categories: [pc])

      visit root_path
      fill_in 'Busca:', with: 'Natal'
      click_on 'Pesquisar'

      expect(current_path).to eq search_path
      expect(page).to have_content('Natal')
      expect(page).to have_content('NATAL10')
      expect(page).to have_content('Natal2020')
      expect(page).to have_content('NATAL2020')
      expect(page).not_to have_content('Black20')
      expect(page).not_to have_content('BLACKF20')
    end

    scenario 'no results' do
      visit root_path
      fill_in 'Busca:', with: 'Natal'
      click_on 'Pesquisar'

      expect(current_path).to eq search_path
      expect(page).to have_content('Nenhum resultado encontrado para a pesquisa "Natal" em promoções')
    end
  end
end
