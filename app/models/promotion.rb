class Promotion < ApplicationRecord
  has_many :coupons
  has_one :promotion_approval
  belongs_to :user

  validates :name, :code, :discount_rate, :expiration_date, :coupon_quantity, presence: true
  validates :code, uniqueness: true

  def generate_coupons!
    Coupon.transaction do
      1.upto(coupon_quantity).map do |index|
        coupons.create!(code: "#{code}-#{format('%04d', index)}")
      end
    end
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
end
