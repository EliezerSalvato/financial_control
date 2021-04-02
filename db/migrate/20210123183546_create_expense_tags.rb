class CreateExpenseTags < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_tags do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
