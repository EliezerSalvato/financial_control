class Expense::Fetch < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    expenses = Expense.by_user_id(user.id).ordered

    Success { { data: expenses } }
  end
end
