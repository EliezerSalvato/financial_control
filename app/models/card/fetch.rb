class Card::Fetch < Micro::Case
  attributes :user, :params

  validates :user, type: User
  validates :params, type: ActionController::Parameters

  def call!
    cards = Card.by_user_id(user.id).ordered

    Success { { data: cards } }
  end
end
