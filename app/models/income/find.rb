class Income::Find < Micro::Case
  attributes :user, :income_id

  validates :user, kind: User
  validates :income_id, numericality: { only_integer: true }

  def call!
    income = user.incomes.find_by(id: income_id)

    return Success { { income: income } } if income.present?

    Failure(:income_not_found)
  end
end
