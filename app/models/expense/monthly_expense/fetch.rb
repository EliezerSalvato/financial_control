class Expense::MonthlyExpense::Fetch < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    expenses = MonthlyExpense.by_month_and_year(user.id, params[:month], params[:year])

    Success { { data: expenses } }
  end
end
