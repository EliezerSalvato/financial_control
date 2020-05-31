class Expense::CashRecurringExpense::Update < Micro::Case
  attributes :expense, :params

  validates :expense, type: Expense
  validates :params, type: ActionController::Parameters

  def call!
    expense_params = Expense::CashRecurringExpense::Params.to_save(params)
    expense.update(expense_params)

    Success { { expense: expense } }
  rescue => error
    Failure(error)
  end
end
