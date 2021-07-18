class Expense::FindLastExpense < Micro::Case
  attributes :user

  validates :user, kind: User

  def call!
    expense = user.expenses.last

    return Success { { expense: expense } } if expense.present?

    Failure(:expense_not_found)
  end
end
