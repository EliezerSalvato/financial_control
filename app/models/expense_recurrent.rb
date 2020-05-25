class ExpenseRecurrent < ApplicationRecord
  audited associated_with: :expense

  belongs_to :expense

  validates :expense, :date, :value, presence: true
end
