user = User.create!(email: 'user@email.com', password: '123456')
promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: '22/12/2033', user: user)
promotion.generate_coupons!
