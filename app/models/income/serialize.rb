class Income::Serialize
  def self.as_json(income)
    income.as_json(include: [:card, :income_recurrents], except: [:user_id])
  end

  def self.collection_as_json(incomes)
    incomes.map { |income| as_json(income) }
  end

  class AsJson < Micro::Case
    attribute :income

    validates :income, type: Income

    def call!
      return Success { { data: Income::Serialize.as_json(income) } } if income.valid?

      Failure(:invalid_income) { { errors: income.errors.as_json } }
    end
  end
end
