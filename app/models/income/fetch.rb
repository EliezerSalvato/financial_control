class Income::Fetch < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    incomes = Income.by_user_id(user.id).ordered

    Success { { data: incomes } }
  end
end
