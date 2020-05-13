class Category::Fetch < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    categories = Category.by_user_id(user.id).ordered

    Success { { data: categories } }
  end
end
