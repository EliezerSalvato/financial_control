class Debit < ApplicationRecord
  audited

  has_one :card, as: :card, dependent: :destroy, autosave: true

  validates :current_money, presence: true
end
