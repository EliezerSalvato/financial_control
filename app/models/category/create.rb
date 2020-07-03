class Category::Create < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    category_params = Category::Params.to_save(params)

    category = user.categories.create(category_params)

    Success { { category: category} }
  rescue ActionController::ParameterMissing => error
    Failure(:parameter_missing) { { message: error.message } }
  end
end
