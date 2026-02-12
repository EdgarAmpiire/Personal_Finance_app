class Budget < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :limit_cents, numericality: { only_integer: true, greater_than: 0 }

  def limit
    limit_cents.to_i / 100.0
  end

  def limit=(value)
    self.limit_cents = money_to_cents(value)
  end

  private

  def money_to_cents(value)
    cleaned = value.to_s.delete(",").strip
    raise ArgumentError, "Limit cannot be blank" if cleaned.blank?
    (BigDecimal(cleaned) * 100).to_i
  end
end
