class IncomeTag < ApplicationRecord
  audited associated_with: :income

  belongs_to :income
  belongs_to :tag

  validates :income, :tag, presence: true
end
