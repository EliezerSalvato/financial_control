class Income::Fetch < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    incomes = Income.by_user_id(user.id).ordered

    Success { { data: incomes } }
  end
end
