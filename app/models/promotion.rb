class Promotion < ApplicationRecord
  has_many :coupons

  validates :name, :code, :discount_rate, :expiration_date, :coupon_quantity, presence: true
  validates :code, uniqueness: true

  def generate_coupons!
    Coupon.transaction do
      1.upto(coupon_quantity).map do |index|
        coupons.create!(code: "#{code}-#{format('%04d', index)}")
      end
    end
  end
end
