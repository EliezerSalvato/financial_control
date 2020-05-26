class Income < ApplicationRecord
  audited associated_with: :card

  belongs_to :user
  belongs_to :card, class_name: '::Card', optional: true
  belongs_to :group, optional: true
  belongs_to :category, optional: true

  has_many :income_recurrents, dependent: :destroy, index_errors: true

  accepts_nested_attributes_for :income_recurrents, allow_destroy: true

  validates :category, :description, :income_type, presence: true
  validates :card, presence: true, if: :card_required?
  validate :keep_income_type, if: :persisted?

  with_options presence: true do
    validates :value, if: :value_required?
    validates :date, if: :date_required?
    validates :end_at, if: :end_at_required?
  end

  has_enumeration_for :income_type, with: IncomeTypes, create_helpers: true

  scope :by_description, ->(description) { where("description ILIKE '%#{description}%'") }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :by_card_id, ->(card_id) { where(card_id: card_id) }
  scope :by_income_type, ->(income_type) { where(income_type: income_type) }
  scope :ordered, -> { order(updated_at: :desc, description: :asc) }

  attr_accessor :quantity, :value, :date

  after_initialize :initialize_required_attr_accessor

  private

  def initialize_required_attr_accessor
    return unless persisted?

    self.value = 0
    self.date = Date.current
  end

  def keep_income_type
    errors.add(:income_type, :cannot_be_changed) if income_type != income_type_was
  end

  def valid_income_type?
    return if income_type.blank?

    raise "Unknown income_type: #{income_type}" if IncomeTypes.key_for(income_type).blank?

    true
  end

  def card_required?
    return unless valid_income_type?

    salary?
  end

  def value_required?
    return unless valid_income_type?

    cash?
  end

  def date_required?
    return unless valid_income_type?

    cash?
  end

  def end_at_required?
    return unless valid_income_type?

    cash?
  end
end
