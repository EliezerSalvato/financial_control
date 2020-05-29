class Income::Update < Micro::Case
  flow Income::Find,
       self.call!

  attributes :income, :params

  validates :income, type: Income
  validates :params, type: ActionController::Parameters

  def call!
    income_params = Income::Params.to_save(params)

    result = update_by_type(params[:income_type], income_params)
    income = result.value[:income] if result.present?
    income ||= income.update(income_params)

    Success { attributes }
  rescue ActionController::ParameterMissing => error
    Failure(:parameter_missing) { { message: error.message } }
  end

  private

  def update_by_type(income_type, income_params)
    return if income_type.blank?

    income_by_type = case income_type
                     when IncomeTypes::CARD
                       Income::Card::Update
                     when IncomeTypes::SALARY
                       Income::Salary::Update
                     when IncomeTypes::CASH
                       Income::Cash::Update
                     end

    income_by_type.call(income: income, params: income_params)
  end
end
