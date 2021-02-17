class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy
  has_many :product_category_promotions, dependent: :destroy
  has_many :product_categories, through: :product_category_promotions

  validate :at_least_one_category

  has_one :promotion_approval

  belongs_to :user

  validates :name, :code, :discount_rate, :expiration_date, :coupon_quantity, presence: true
  validates :code, uniqueness: true

  def generate_coupons!
    return unless approved?

    Coupon.transaction do
      (coupons.size + 1).upto(coupon_quantity).map do |index|
        coupons.create!(code: "#{code}-#{format('%04d', index)}")
      end
    end
  end

  def all_coupons_generated?
    coupons.count == coupon_quantity
  end

  def approve!(approval_user)
    PromotionApproval.create(promotion: self, user: approval_user)
  end

  def approved?
    !!promotion_approval
  end

  def approver
    promotion_approval&.user
  end

  def approved_at
    promotion_approval&.created_at
  end

  private

  def at_least_one_category
    errors.add(:product_categories, 'não vinculadas') if product_categories.empty?
  end
end
