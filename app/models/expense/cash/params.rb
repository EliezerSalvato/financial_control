class Expense::Cash::Params
  def self.to_save(params)
    params.permit(
      :description,
      :category_id,
      :expense_type,
      :end_at,
      expense_tags_attributes: [
        :id, :tag_id, :_destroy
      ]
    ).merge(
      value: params[:value],
      date: params[:date]
    )
  end
end
