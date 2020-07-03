class Income::Destroy < Micro::Case
  flow Income::Find,
       self.call!

  attribute :income

  validates :income, kind: Income

  def call!
    income.destroy if income.valid?

    Success { attributes }
  end
end
