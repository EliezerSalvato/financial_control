class Expense::CardRecurringExpense::Update < Micro::Case
  attributes :expense, :params

  validates :expense, kind: Expense
  validates :params, kind: ActionController::Parameters

  def call!
    expense_params = Expense::CardRecurringExpense::Params.to_save(params)
    expense.update(expense_params)

    Success { { expense: expense } }
  rescue => error
    Failure(error)
  end
end
