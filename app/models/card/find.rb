class Card::Find < Micro::Case
  attributes :user, :card_id

  validates :user, type: User
  validates :card_id, numericality: { only_integer: true }

  def call!
    card = user.cards.find_by(id: card_id)

    return Success { { card: card } } if card.present?

    Failure(:card_not_found)
  end
end
