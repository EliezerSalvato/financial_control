class Income::CardRecurringIncome::Params
  def self.to_save(params)
    params.permit(
      :description,
      :card_id,
      :category_id,
      :income_type,
      :end_at,
      income_tags_attributes: [
        :id, :tag_id, :_destroy
      ],
      income_recurrents_attributes: [
        :id, :date, :value, :_destroy
      ]
    ).merge(
      quantity: params[:quantity]
    )
  end
end
