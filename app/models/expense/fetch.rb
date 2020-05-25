class Expense::Fetch < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    expenses = Expense.by_user_id(user.id).ordered

    Success { { data: expenses } }
  end
end
