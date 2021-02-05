class Promotion < ApplicationRecord
  has_many :coupons

  validates :name, :code, :discount_rate, :expiration_date, :coupon_quantity, presence: true
  validates :code, uniqueness: true
end
