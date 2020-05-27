class CreateDebits < ActiveRecord::Migration[6.0]
  def change
    create_table :debits do |t|
      t.decimal :current_money, null: false, default: 0.0

      t.timestamps
    end
  end
end
