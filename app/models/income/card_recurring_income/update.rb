class Income::CardRecurringIncome::Update < Micro::Case
  attributes :income, :params

  validates :income, kind: Income
  validates :params, kind: ActionController::Parameters

  def call!
    income_params = Income::CardRecurringIncome::Params.to_save(params)
    income.update(income_params)

    Success { { income: income } }
  rescue => error
    Failure(error)
  end
end
