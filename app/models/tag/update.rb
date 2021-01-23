class Tag
  class Update < Micro::Case
    flow Find,
         self.call!

    attributes :tag, :params

    validates :tag, kind: Tag
    validates :params, kind: ActionController::Parameters

    def call!
      tag_params = Params.to_save(params)

      tag.update(tag_params)

      Success { attributes }
    rescue ActionController::ParameterMissing => e
      Failure(:parameter_missing) { { message: e.message } }
    end
  end
end
