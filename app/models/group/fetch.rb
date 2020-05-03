class Group::Fetch < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    groups = Group.by_user_id(user.id).ordered

    Success { { data: groups } }
  end
end
