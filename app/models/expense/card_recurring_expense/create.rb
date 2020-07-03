class Expense::CardRecurringExpense::Create < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    expense_params = Expense::CardRecurringExpense::Params.to_save(params)
    expense = user.expenses.create(expense_params)

    Success { { expense: expense } }
  rescue => error
    Failure(error)
  end
end
