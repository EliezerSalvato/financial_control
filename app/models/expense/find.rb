class Expense::Find < Micro::Case
  attributes :user, :expense_id

  validates :user, kind: User
  validates :expense_id, numericality: { only_integer: true }

  def call!
    expense = user.expenses.find_by(id: expense_id)

    return Success { { expense: expense } } if expense.present?

    Failure(:expense_not_found)
  end
end
