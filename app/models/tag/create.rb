class Tag
  class Create < Micro::Case
    attributes :user, :params

    validates :user, kind: User
    validates :params, kind: ActionController::Parameters

    def call!
      tag_params = Params.to_save(params)

      tag = user.tags.create(tag_params)

      Success { { tag: tag} }
    rescue ActionController::ParameterMissing => error
      Failure(:parameter_missing) { { message: error.message } }
    end
  end
end
