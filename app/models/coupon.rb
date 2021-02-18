class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0, burned: 5, inactive: 10 }
end
