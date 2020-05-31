class Income::CashRecurringIncome::Update < Micro::Case
  attributes :income, :params

  validates :income, type: Income
  validates :params, type: ActionController::Parameters

  def call!
    income_params = Income::CashRecurringIncome::Params.to_save(params)
    income.update(income_params)

    Success { { income: income } }
  rescue => error
    Failure(error)
  end
end
