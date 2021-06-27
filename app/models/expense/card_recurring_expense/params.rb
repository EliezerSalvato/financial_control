class Expense::CardRecurringExpense::Params
  def self.to_save(params)
    params.permit(
      :description,
      :card_id,
      :category_id,
      :expense_type,
      :end_at,
      expense_tags_attributes: [
        :id, :tag_id, :_destroy
      ],
      expense_recurrents_attributes: [
        :id, :date, :value, :_destroy
      ]
    ).merge(
      quantity: params[:quantity]
    )
  end
end
