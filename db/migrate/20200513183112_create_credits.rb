class CreateCredits < ActiveRecord::Migration[6.0]
  def change
    create_table :credits do |t|
      t.decimal :limit, null: false
      t.decimal :super_limit
      t.integer :due_day, null: false
      t.integer :closing_day, null: false

      t.timestamps
    end
  end
end
