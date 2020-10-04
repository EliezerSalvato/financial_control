class Card::Destroy < Micro::Case
  flow Card::Find,
       self.call!

  attribute :card

  validates :card, kind: Card

  def call!
    card.destroy if card.valid?

    Success { attributes }
  end
end
