class Group::Find < Micro::Case
  attributes :user, :group_id

  validates :user, kind: User
  validates :group_id, numericality: { only_integer: true }

  def call!
    group = user.groups.find_by(id: group_id)

    return Success { { group: group } } if group.present?

    Failure(:group_not_found)
  end
end
