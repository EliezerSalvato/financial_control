class Group::Create < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    group_params = Group::Params.to_save(params)

    group = user.groups.create(group_params)

    Success { { group: group} }
  rescue ActionController::ParameterMissing => error
    Failure(:parameter_missing) { { message: error.message } }
  end
end
