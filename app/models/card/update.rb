class Card::Update < Micro::Case
  flow Card::Find,
       self.call!

  attributes :card, :params

  validates :card, kind: Card
  validates :params, kind: ActionController::Parameters

  def call!
    card_params = Card::Params.to_save(params)

    card.update(card_params)

    Success { attributes }
  rescue ActionController::ParameterMissing => e
    Failure(:parameter_missing) { { message: e.message } }
  end
end
