class Income::Card::Params
  def self.to_save(params)
    params.permit(
      :description,
      :card_id,
      :category_id,
      :income_type,
      :end_at,
      income_tags_attributes: [
        :id, :tag_id, :_destroy
      ]
    ).merge(
      value: params[:value],
      date: params[:date]
    )
  end
end
