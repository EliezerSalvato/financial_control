class Expense < ApplicationRecord
  audited associated_with: :card

  belongs_to :user
  belongs_to :card, class_name: '::Card', optional: true
  belongs_to :group, optional: true
  belongs_to :category, optional: true

  has_many :expense_recurrents, dependent: :destroy, index_errors: true

  accepts_nested_attributes_for :expense_recurrents, allow_destroy: true

  validates :category, :description, :expense_type, presence: true
  validates :card, presence: true, if: :card_required?
  validate :keep_expense_type, if: :persisted?

  with_options presence: true do
    validates :quantity, if: :quantity_required?
    validates :value, if: :value_required?
    validates :date, if: :date_required?
    validates :end_at, if: :end_at_required?
  end

  has_enumeration_for :expense_type, with: ExpenseTypes, create_helpers: true

  scope :by_description, ->(description) { where("description ILIKE '%#{description}%'") }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :by_card_id, ->(card_id) { where(card_id: card_id) }
  scope :by_expense_type, ->(expense_type) { where(expense_type: expense_type) }
  scope :ordered, -> { order(updated_at: :desc, description: :asc) }

  attr_accessor :quantity, :value, :date

  after_initialize :initialize_attr_accessor

  private

  def initialize_attr_accessor
    return unless persisted?

    self.quantity = 1
    self.value = 0
    self.date = Date.current
  end

  def keep_expense_type
    errors.add(:expense_type, :cannot_be_changed) if expense_type != expense_type_was
  end

  def valid_expense_type?
    return if expense_type.blank?

    raise "Unknown expense_type: #{expense_type}" if ExpenseTypes.key_for(expense_type).blank?

    true
  end

  def card_required?
    return unless valid_expense_type?

    (card? || installment? || recurring_installments? || card_recurring_expense?)
  end

  def quantity_required?
    return unless valid_expense_type?

    (installment? || recurring_installments?)
  end

  def value_required?
    return unless valid_expense_type?

    (card? || installment? || recurring_installments? || cash?)
  end

  def date_required?
    return unless valid_expense_type?

    (card? || installment? || recurring_installments? || cash?)
  end

  def end_at_required?
    return unless valid_expense_type?

    (card? || installment? || recurring_installments? || cash?)
  end
end
