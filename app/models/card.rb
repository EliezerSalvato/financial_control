class Card < ApplicationRecord
  audited associated_with: :card

  belongs_to :user
  belongs_to :card, polymorphic: true, dependent: :destroy

  accepts_nested_attributes_for :card, allow_destroy: true

  validates :name, :card_type, presence: true
  validates :name, uniqueness: { scope: :user }
  validate :keep_card_type, if: :persisted?

  has_enumeration_for :card_type, with: CardTypes, create_helpers: true

  scope :by_name, ->(name) { where("name ILIKE '%#{name}%'") }
  scope :by_card_type, ->(card_type) { where(card_type: card_type) }
  scope :by_active, ->(active) { where(active: active) }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(active: :desc, name: :asc) }

  def description
    name
  end

  def build_card(params)
    return if card_type.blank?

    raise "Unknown card_type: #{card_type}" if CardTypes.value_for(card_type).blank?

    self.card = card_type.constantize.new(params)
  end

  def keep_card_type
    errors.add(:card_type, :cannot_be_changed) if card_type != card_type_was
  end
end
