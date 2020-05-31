class Expense::Update < Micro::Case
  flow Expense::Find,
       self.call!

  attributes :expense, :params

  validates :expense, type: Expense
  validates :params, type: ActionController::Parameters

  def call!
    expense_params = Expense::Params.to_save(params)

    result = update_by_type(params[:expense_type], expense_params)
    expense = result.value[:expense] if result.present?
    expense ||= expense.update(expense_params)

    Success { attributes }
  rescue ActionController::ParameterMissing => error
    Failure(:parameter_missing) { { message: error.message } }
  end

  private

  def update_by_type(expense_type, expense_params)
    return if expense_type.blank?

    expense_by_type = case expense_type
                      when ExpenseTypes::CARD
                        Expense::Card::Update
                      when ExpenseTypes::INSTALLMENT, ExpenseTypes::RECURRING_INSTALLMENTS
                        Expense::Installment::Update
                      when ExpenseTypes::CARD_RECURRING_EXPENSE
                        Expense::CardRecurringExpense::Update
                      when ExpenseTypes::CASH
                        Expense::Cash::Update
                      when ExpenseTypes::CASH_RECURRING_EXPENSE
                        Expense::CashRecurringExpense::Update
                      end

    expense_by_type.call(expense: expense, params: expense_params)
  end
end
