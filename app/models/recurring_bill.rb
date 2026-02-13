class RecurringBill < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :amount_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :due_day, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
  validates :active, inclusion: { in: [ true, false ] }

  def amount
    amount_cents.to_i / 100.0
  end

  def amount=(value)
    self.amount_cents = money_to_cents(value)
  end

  def due_label
    "Monthly - #{ordinal(due_day)}"
  end

  def overdue?(today = Date.current)
    return false unless active?
    return false if last_paid_on.present? && last_paid_on.month == today.month && last_paid_on.year == today.year

    due_date = Date.new(today.year, today.month, [ due_day, Date.civil(today.year, today.month, -1).day ].min)
    today > due_date
  end

  private

  def money_to_cents(value)
    cleaned = value.to_s.delete(",").strip
    raise ArgumentError, "Amount can't be blank" if cleaned.blank?
    cents = (BigDecimal(cleaned) * 100).to_i
    raise ArgumentError, "Amount must be greater than 0" if cents <= 0
    cents
  end

  def ordinal(n)
    n = n.to_i
    return "#{n}th" if (11..13).include?(n % 100)

    case n % 10
    when 1 then "#{n}st"
    when 2 then "#{n}nd"
    when 3 then "#{n}rd"
    end
  end
end
