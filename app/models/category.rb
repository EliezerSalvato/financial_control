class Category < ApplicationRecord
  audited

  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user }

  scope :by_name, ->(name) { where("name ILIKE '%#{name}%'") }
  scope :by_active, ->(active) { where(active: active) }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(active: :desc, name: :asc) }

  def description
    name
  end
end
