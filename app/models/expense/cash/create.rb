class Expense::Cash::Create < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    expense_params = Expense::Cash::Params.to_save(params)
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
