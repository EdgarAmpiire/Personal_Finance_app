class Category < ApplicationRecord
   DEFAULT_NAMES = [
    "Salary",
    "Business / Side Hustle",
    "Groceries",
    "Eating Out",
    "Rent",
    "Utilities",
    "Transport",
    "Airtime/Data",
    "Health",
    "Savings",
    "Loan Repayment",
    "Family Support",
    "Entertainment",
    "Fees/Charges",
    "Other"
  ].freeze

  belongs_to :user
  has_many :transactions, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
