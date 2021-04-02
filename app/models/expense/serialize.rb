class Expense::Serialize
  def self.as_json(expense)
    expense.as_json(include: [:card, :expense_recurrents, expense_tags: { include: :tag }], except: [:user_id])
  end

  def self.collection_as_json(expenses)
    expenses.map { |expense| as_json(expense) }
  end

  class AsJson < Micro::Case
    attribute :expense

    validates :expense, kind: Expense

    def call!
      return Success { { data: Expense::Serialize.as_json(expense) } } if expense.valid?

      Failure(:invalid_expense) { { errors: expense.errors.as_json } }
    end
  end
end
