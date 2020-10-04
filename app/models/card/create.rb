class Card::Create < Micro::Case
  attributes :user, :params

  validates :user, kind: User
  validates :params, kind: ActionController::Parameters

  def call!
    card_params = Card::Params.to_save(params)

    card = user.cards.create(card_params)

    Success { { card: card} }
  rescue ActionController::ParameterMissing => error
    Failure(:parameter_missing) { { message: error.message } }
  end
end
