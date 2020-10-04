class Group < ApplicationRecord
  audited

  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user }

  scope :active, -> { where(active: true) }

  def description
    name
  end
end
