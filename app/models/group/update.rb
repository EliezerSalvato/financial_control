class Group::Update < Micro::Case
  flow Group::Find,
       self.call!

  attributes :group, :params

  validates :group, type: Group
  validates :params, type: ActionController::Parameters

  def call!
    group_params = Group::Params.to_save(params)

    group.update(group_params)

    Success { attributes }
  rescue ActionController::ParameterMissing => e
    Failure(:parameter_missing) { { message: e.message } }
  end
end
