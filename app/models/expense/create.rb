class Expense::Create < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    expense_params = Expense::Params.to_save(params)

    result = create_by_type(params[:expense_type], expense_params)
    expense = result.value[:expense] if result.present?
    expense ||= user.expenses.create(expense_params)

    Success { { expense: expense } }
  rescue ActionController::ParameterMissing => error
    Failure(:parameter_missing) { { message: error.message } }
  end

  private

  def create_by_type(expense_type, expense_params)
    return if expense_type.blank?

    expense = case expense_type
              when ExpenseTypes::CARD
                Expense::Card::Create
              when ExpenseTypes::INSTALLMENT, ExpenseTypes::RECURRING_INSTALLMENTS
                Expense::Installment::Create
              when ExpenseTypes::CARD_RECURRING_EXPENSE
                Expense::CardRecurringExpense::Create
              when ExpenseTypes::CASH
                Expense::Cash::Create
              when ExpenseTypes::CASH_RECURRING_EXPENSE
                Expense::CashRecurringExpense::Create
              end

    expense.call(user: user, params: expense_params)
  end
end
