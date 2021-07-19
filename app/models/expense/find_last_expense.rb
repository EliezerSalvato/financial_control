class Expense::FindLastExpense < Micro::Case
  attributes :user

  validates :user, kind: User

  def call!
    expense = user.expenses.last

    Success { { expense: expense } }
  rescue
    Failure(:invalid_expense)
  end
end
