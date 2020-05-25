class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.references :user, foreign_key: true
      t.references :card, foreign_key: true
      t.references :group, foreign_key: true
      t.references :category, foreign_key: true
      t.string :description, null: false, index: true
      t.string :expense_type, null: false
      t.date :end_at

      t.timestamps
    end
  end
end
