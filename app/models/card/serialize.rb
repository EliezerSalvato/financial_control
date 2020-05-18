class Card::Serialize
  def self.as_json(card)
    card.as_json(include: :card, except: [:user_id], methods: :description)
  end

  def self.collection_as_json(cards)
    cards.map { |card| as_json(card) }
  end

  class AsJson < Micro::Case
    attribute :card

    validates :card, type: Card

    def call!
      return Success { { data: Card::Serialize.as_json(card) } } if card.valid?

      Failure(:invalid_card) { { errors: card.errors.as_json } }
    end
  end
end
