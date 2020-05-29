class CreateMonthlyIncomes < ActiveRecord::Migration[6.0]
  def change
    create_table :monthly_incomes do |t|
      t.string :income_type
      t.string :description
      t.numeric :value
      t.date :date

      t.timestamps
    end
  end
end
