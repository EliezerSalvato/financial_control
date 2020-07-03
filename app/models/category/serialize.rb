class Category::Serialize
  def self.as_json(category)
    category.as_json(except: [:user_id], methods: :description)
  end

  def self.collection_as_json(categories)
    categories.map { |category| as_json(category) }
  end

  class AsJson < Micro::Case
    attribute :category

    validates :category, kind: Category

    def call!
      return Success { { data: Category::Serialize.as_json(category) } } if category.valid?

      Failure(:invalid_category) { { errors: category.errors.as_json } }
    end
  end
end
