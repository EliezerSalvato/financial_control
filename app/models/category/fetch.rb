class Category::Fetch < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    categories = Category.by_user_id(user.id).ordered

    Success { { data: categories } }
  end
end
