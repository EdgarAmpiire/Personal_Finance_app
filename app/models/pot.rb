class Pot < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :target_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :saved_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def target
    target_cents.to_i / 100.0
  end

  def saved
    saved_cents.to_i / 100.0
  end

  def target=(value)
    self.target_cents = money_to_cents(value)
  end

  def saved=(value)
    self.saved_cents = money_to_cents(value)
  end

  def progress_ratio
    return 0.0 if target_cents.to_i <= 0
    [ saved_cents.to_f / target_cents, 1.0 ].min
  end

  def progress_percent
    (progress_ratio * 100).round(1)
  end

  def add_money!(amount_cents)
    raise ArgumentError, "amount must be positive" if amount_cents.to_i <= 0
    update!(saved_cents: saved_cents + amount_cents.to_i)
  end

  def withdraw_money!(amount_cents)
    raise ArgumentError, "amount must be positive" if amount_cents.to_i <= 0
    raise ArgumentError, "insufficient funds" if amount_cents.to_i > saved_cents
    update!(saved_cents: saved_cents - amount_cents.to_i)
  end

  private

  def money_to_cents(value)
    cleaned = value.to_s.delete(",").strip
    return 0 if cleaned.blank?
    [ (BigDecimal(cleaned) * 100).to_i, 0 ].max
  end
end
