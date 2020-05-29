class Income::MonthlyIncome::Fetch < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    incomes = MonthlyIncome.by_month_and_year(params[:month], params[:year])

    Success { { data: incomes } }
  end
end
