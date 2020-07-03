class Expense::Installment::Create < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    expense_params = Expense::Installment::Params.to_save(params)
    expense = user.expenses.create(expense_params.merge(recurrence))

    Success { { expense: expense } }
  rescue => error
    Failure(error)
  end

  private

  def recurrence
    {
      expense_recurrents_attributes: [
        date: params[:date],
        value: params[:value]
      ]
    }
  end
end
