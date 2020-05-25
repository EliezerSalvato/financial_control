class CreateExpenseRecurrents < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_recurrents do |t|
      t.references :expense, foreign_key: true
      t.date :date, null: false
      t.decimal :value, null: false

      t.timestamps
    end
  end
end
