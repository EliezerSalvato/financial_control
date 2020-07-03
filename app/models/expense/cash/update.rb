class Expense::Cash::Update < Micro::Case
  attributes :expense, :params

  validates :expense, kind: Expense
  validates :params, kind: ActionController::Parameters

  def call!
    expense_params = Expense::Cash::Params.to_save(params)
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
