class Expense::MonthlyExpense::Fetch < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    expenses = MonthlyExpense.by_month_and_year(params[:month], params[:year])

    Success { { data: expenses } }
  end
end
