class Tag < ApplicationRecord
  audited

  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user }

  def description
    name
  end
end
