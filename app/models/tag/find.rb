class Tag
  class Find < Micro::Case
    attributes :user, :tag_id

    validates :user, kind: User
    validates :tag_id, numericality: { only_integer: true }

    def call!
      tag = user.tags.find_by(id: tag_id)

      return Success { { tag: tag } } if tag.present?

      Failure(:tag_not_found)
    end
  end
end
