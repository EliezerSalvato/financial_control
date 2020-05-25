class Expense::Installment::Update < Micro::Case
  attributes :expense, :params

  validates :expense, type: Expense
  validates :params, type: ActionController::Parameters

  def call!
    expense_params = Expense::Installment::Params.to_save(params)
    expense.update(expense_params.merge(recurrence))

    Success { { expense: expense } }
  rescue => error
    Failure(error)
  end

  private

  def recurrence
    id = expense.expense_recurrents.first&.id

    {
      expense_recurrents_attributes: [
        id: id,
        date: params[:date],
        value: params[:value]
      ]
    }
  end
end
