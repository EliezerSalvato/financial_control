class Expense::Installment::Params
  def self.to_save(params)
    params.permit(
      :description,
      :card_id,
      :category_id,
      :expense_type,
      :end_at,
      expense_tags_attributes: [
        :id, :tag_id, :_destroy
      ]
    ).merge(
      quantity: params[:quantity],
      value: params[:value],
      date: params[:date]
    )
  end
end
