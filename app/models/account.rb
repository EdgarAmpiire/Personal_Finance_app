class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true
  validates :account_type, presence: true

  def balance_cents
    transactions.sum(:amount_cents)
  end

  def balance
    balance_cents / 100.0
  end
end
