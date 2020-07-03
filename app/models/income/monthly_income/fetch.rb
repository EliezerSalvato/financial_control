class Income::MonthlyIncome::Fetch < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    incomes = MonthlyIncome.by_month_and_year(user.id, params[:month], params[:year])

    Success { { data: incomes } }
  end
end
