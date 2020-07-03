class Group::Fetch < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    groups = Group.by_user_id(user.id).ordered

    filter_as_json = params[:filter] || '{}'
    filter = JSON.parse(filter_as_json).with_indifferent_access

    if name = filter[:by_name]
      groups = groups.by_name(name)
    end

    if name = filter[:by_name]
      groups = groups.by_name(name)
    end

    if active = filter[:by_active]
      groups = groups.by_active(active)
    end

    Success { { relation: groups } }
  end
end
