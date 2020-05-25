class Expense::Params
  def self.to_save(params)
    params.require(:expense).permit(
      :description,
      :card_id,
      :group_id,
      :category_id,
      :expense_type,
      :end_at,
      expense_recurrents_attributes: [
        :id, :date, :value, :_destroy
      ]
    ).merge(
      quantity: params[:quantity],
      value: params[:value],
      date: params[:date]
    )
  end
end
