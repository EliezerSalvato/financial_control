class Income::CashRecurringIncome::Create < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    income_params = Income::CashRecurringIncome::Params.to_save(params)
    income = user.incomes.create(income_params)

    Success { { income: income } }
  rescue => error
    Failure(error)
  end
end
