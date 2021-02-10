class PromotionApproval < ApplicationRecord
  belongs_to :promotion
  belongs_to :user

  validate :different_user

  private

  def different_user
    errors.add(:user, 'não pode ser o criador da promoção') if user == promotion&.user
  end
end
