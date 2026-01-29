class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :account
  belongs_to :category, optional: true

  validates :description, presence: true
  validates :amount_cents, presence: true, numericality: { only_integer: true }
  validates :occurred_on, presence: true

  validate :account_belongs_to_user
  validate :category_belongs_to_user

  def amount
    amount_cents.to_i / 100.0
  end

  private

  def account_belongs_to_user
    return if account.blank? || user.blank?
    errors.add(:account, "must belong to the current user") if account.user_id != user_id
  end

  def category_belongs_to_user
    return if category.blank? || user.blank?
    errors.add(:category, "must belong to the current user") if category.user_id != user_id
  end
end
