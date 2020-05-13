class Category::Destroy < Micro::Case
  flow Category::Find,
       self.call!

  attribute :category

  validates :category, type: Category

  def call!
    category.destroy if category.valid?

    Success { attributes }
  end
end
