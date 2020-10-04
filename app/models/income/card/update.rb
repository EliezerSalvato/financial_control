class Income::Card::Update < Micro::Case
  attributes :income, :params

  validates :income, kind: Income
  validates :params, kind: ActionController::Parameters

  def call!
    income_params = Income::Card::Params.to_save(params)
    income.update(income_params.merge(recurrence))

    Success { { income: income } }
  rescue => error
    Failure(error)
  end

  private

  def recurrence
    id = income.income_recurrents.first&.id

    {
      income_recurrents_attributes: [
        id: id,
        date: params[:date],
        value: params[:value]
      ]
    }
  end
end
