class ProductCategory < ApplicationRecord
  has_many :product_category_promotions
  has_many :promotions, through: :product_category_promotions

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
end
