class IncomeRecurrent < ApplicationRecord
  audited associated_with: :income

  belongs_to :income

  validates :income, :date, :value, presence: true
end
