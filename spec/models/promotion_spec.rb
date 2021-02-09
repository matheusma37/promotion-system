require 'rails_helper'

describe Promotion do
  context 'validation' do
    it 'attributes cannot be blank' do
      promotion = Promotion.new

      expect(promotion.valid?).to eq false
      expect(promotion.errors.count).to eq 5
    end

    it 'discription is optional' do
      promotion = Promotion.new(
        name: 'Natal', description: '', code: 'NAT',
        coupon_quantity: 10, discount_rate: 10,
        expiration_date: '2021-10-10'
      )

      expect(promotion.valid?).to eq true
    end
    it 'error messages are in portuguese' do
      promotion = Promotion.new

      promotion.valid?

      expect(promotion.errors[:name]).to include('não pode ficar em branco')
      expect(promotion.errors[:code]).to include('não pode ficar em branco')
      expect(promotion.errors[:discount_rate]).to include('não pode ficar em '\
                                                          'branco')
      expect(promotion.errors[:coupon_quantity]).to include('não pode ficar em'\
                                                            ' branco')
      expect(promotion.errors[:expiration_date]).to include('não pode ficar em'\
                                                            ' branco')
    end

    it 'code must be uniq' do
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
      promotion = Promotion.new(code: 'NATAL10')

      promotion.valid?

      expect(promotion.errors[:code]).to include('já está em uso')
    end
  end

  context '#generate_coupons!' do
    it 'generate coupons of coupon_quantity' do
      promotion = Promotion.create!(name: 'Natal',
                                    description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10,
                                    coupon_quantity: 100,
                                    expiration_date: '22/12/2033')

      promotion.generate_coupons!

      expect(promotion.coupons.size).to eq(promotion.coupon_quantity)
      codes = promotion.coupons.pluck(:code)
      expect(codes).to include('NATAL10-0001')
      expect(codes).to include('NATAL10-0100')
      expect(codes).not_to include('NATAL10-0000')
      expect(codes).not_to include('NATAL10-0101')
    end

    it 'do not generate if coupon code already exists' do
      promotion = Promotion.create!(name: 'Natal',
                                    description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10,
                                    coupon_quantity: 100,
                                    expiration_date: '22/12/2033')
      promotion.coupons.create!(code: 'NATAL10-0030')

      expect { promotion.generate_coupons! }.to raise_error(ActiveRecord::RecordNotUnique)

      expect(promotion.coupons.reload.size).to eq(1)
    end

    # TODO: Implementar essa feature
    it 'generate remainder of the coupon codes' do
      pending
      promotion = Promotion.create!(name: 'Natal',
                                    description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10,
                                    coupon_quantity: 100,
                                    expiration_date: '22/12/2033')
      promotion.coupons.create!(code: 'NATAL10-0001')
      promotion.coupons.create!(code: 'NATAL10-0002')
      promotion.coupons.create!(code: 'NATAL10-0003')
      promotion.coupons.create!(code: 'NATAL10-0004')
      promotion.coupons.create!(code: 'NATAL10-0005')

      expect { promotion.generate_coupons! }.to raise_error(ActiveRecord::RecordNotUnique)

      expect(promotion.coupons.size).to eq(promotion.coupon_quantity)
    end
  end
end
