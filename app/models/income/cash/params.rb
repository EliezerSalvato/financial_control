class Income::Cash::Params
  def self.to_save(params)
    params.permit(
      :description,
      :group_id,
      :category_id,
      :income_type,
      :end_at
    ).merge(
      value: params[:value],
      date: params[:date]
    )
  end
end
