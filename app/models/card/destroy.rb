class Card::Destroy < Micro::Case
  flow Card::Find,
       self.call!

  attribute :card

  validates :card, type: Card

  def call!
    card.destroy if card.valid?

    Success { attributes }
  end
end
