class CreateIncomeRecurrents < ActiveRecord::Migration[6.0]
  def change
    create_table :income_recurrents do |t|
      t.references :income, foreign_key: true
      t.date :date, null: false
      t.decimal :value, null: false

      t.timestamps
    end
  end
end
