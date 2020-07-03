class Group
  module FindAll
    class ByUser < Micro::Case
      attributes :user, :params

      validates :user, kind: User
      validates :params, kind: ActionController::Parameters

      def call!
        relation =
          Group
            .where(user_id: user.id)
            .order(active: :desc, name: :asc)

        Success { { relation: relation } }
      end
    end
  end
end
