class Credit < ApplicationRecord
  audited

  has_one :card, as: :card, dependent: :destroy, autosave: true

  validates :limit, :due_day, :closing_day, presence: true

  with_options numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 } do
    validates :due_day, :closing_day
  end
end
