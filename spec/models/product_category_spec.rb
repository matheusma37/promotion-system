require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should have_many(:product_category_promotions) }
    it { should have_many(:promotions) }
  end
end
