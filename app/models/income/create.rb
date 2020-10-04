class Income::Create < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    income_params = Income::Params.to_save(params)

    result = create_by_type(params[:income_type], income_params)
    income = result.value[:income] if result.present?
    income ||= user.incomes.create(income_params)

    Success { { income: income } }
  rescue ActionController::ParameterMissing => error
    Failure(:parameter_missing) { { message: error.message } }
  end

  private

  def create_by_type(income_type, income_params)
    return if income_type.blank?

    income = case income_type
             when IncomeTypes::CARD
               Income::Card::Create
             when IncomeTypes::CARD_RECURRING_INCOME
               Income::CardRecurringIncome::Create
             when IncomeTypes::CASH
               Income::Cash::Create
             when IncomeTypes::CASH_RECURRING_INCOME
               Income::CashRecurringIncome::Create
             end

    income.call(user: user, params: income_params)
  end
end
