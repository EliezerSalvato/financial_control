class ExpenseTag < ApplicationRecord
  audited associated_with: :expense

  belongs_to :expense
  belongs_to :tag

  validates :expense, :tag, presence: true
end
