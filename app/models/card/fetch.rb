class Card::Fetch < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    cards = Card.by_user_id(user.id).ordered

    Success { { data: cards } }
  end
end
