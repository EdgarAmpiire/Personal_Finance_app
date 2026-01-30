class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true
  validates :account_type, presence: true
  validates :starting_balance_cents, numericality: { only_integer: true }, allow_nil: true

  def starting_balance
    (starting_balance_cents || 0) / 100.0
  end

  def starting_balance=(value)
    cleaned = value.to_s.delete(",").strip
    self.starting_balance_cents = (BigDecimal(cleaned) * 100).to_i
  end

  def balance_cents
    (starting_balance_cents || 0) + transactions.sum(:amount_cents)
  end

  def balance
    balance_cents / 100.0
  end
end
