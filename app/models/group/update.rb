class Group::Update < Micro::Case
  flow Group::Find,
       self.call!

  attributes :group, :params

  validates :group, kind: Group
  validates :params, kind: ActionController::Parameters

  def call!
    group_params = Group::Params.to_save(params)

    group.update(group_params)

    Success { attributes }
  rescue ActionController::ParameterMissing => e
    Failure(:parameter_missing) { { message: e.message } }
  end
end
