class Category::Update < Micro::Case
  flow Category::Find,
       self.call!

  attributes :category, :params

  validates :category, type: Category
  validates :params, type: ActionController::Parameters

  def call!
    category_params = Category::Params.to_save(params)

    category.update(category_params)

    Success { attributes }
  rescue ActionController::ParameterMissing => e
    Failure(:parameter_missing) { { message: e.message } }
  end
end
