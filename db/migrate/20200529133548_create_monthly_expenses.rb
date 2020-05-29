class CreateMonthlyExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :monthly_expenses do |t|
      t.string :expense_type
      t.string :description
      t.numeric :value
      t.date :date

      t.timestamps
    end
  end
end
