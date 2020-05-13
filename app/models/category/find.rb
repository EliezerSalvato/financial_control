class Category::Find < Micro::Case
  attributes :user, :category_id

  validates :user, type: User
  validates :category_id, numericality: { only_integer: true }

  def call!
    category = user.categories.find_by(id: category_id)

    return Success { { category: category } } if category.present?

    Failure(:category_not_found)
  end
end
