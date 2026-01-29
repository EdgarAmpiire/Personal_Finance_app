class Category < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
