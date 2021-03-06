class Tag
  class FindAllForUser < Micro::Case
    flow self.call!,
         FilterByParams

    attributes :user, :params

    validates :user, kind: User
    validates :params, kind: ActionController::Parameters

    def call!
      relation = Tag.where(user_id: user.id)
                    .order(active: :desc, name: :asc)

      Success { { relation: relation } }
    end
  end
end
