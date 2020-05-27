class Card::Params
  class << self
    def to_save(params)
      params.require(:card).permit(
        :name,
        :card_id,
        :card_type,
        :active,
        card_attributes: card_params(params[:card_type])
      )
    end

    def card_params(card_type)
      case card_type
      when CardTypes::CREDIT
        credit_params
      when CardTypes::DEBIT
        debit_params
      end
    end

    def credit_params
      [
        :id,
        :limit,
        :super_limit,
        :due_day,
        :closing_day
      ]
    end

    def debit_params
      [
        :id,
        :current_money
      ]
    end
  end
end
