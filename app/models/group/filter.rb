class Group::Filter < Micro::Case
  attributes :relation, :params

  validates :params, kind: ActionController::Parameters
  validates :relation, kind: ActiveRecord::Relation

  def call!
    filter_as_json = params[:filter] || '{}'
    filter = JSON.parse(filter_as_json).with_indifferent_access

    filtered_relation = filter_by_name(relation, filter)
    filtered_relation = filter_by_active(filtered_relation, filter)

    Success { { relation: filtered_relation } }
  end

  private

  def filter_by_name(relation, filter)
    return relation unless value = filter[:by_name]

    relation.where('name ILIKE ?', "%#{value}%")
  end

  def filter_by_active(relation, filter)
    return relation unless value = filter[:by_active]

    relation.where(active: value) if value
  end
end
