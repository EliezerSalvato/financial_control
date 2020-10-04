class Expense::Destroy < Micro::Case
  flow Expense::Find,
       self.call!

  attribute :expense

  validates :expense, kind: Expense

  def call!
    expense.destroy if expense.valid?

    Success { attributes }
  end
end
