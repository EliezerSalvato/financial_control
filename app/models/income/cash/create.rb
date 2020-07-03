class Income::Cash::Create < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    income_params = Income::Cash::Params.to_save(params)
    income = user.incomes.create(income_params.merge(recurrence))

    Success { { income: income } }
  rescue => error
    Failure(error)
  end

  private

  def recurrence
    {
      income_recurrents_attributes: [
        date: params[:date],
        value: params[:value]
      ]
    }
  end
end
