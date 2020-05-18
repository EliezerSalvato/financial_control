class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.references :user, foreign_key: true
      t.column :card_id, :integer, null: false
      t.column :card_type, :string, null: false
      t.string :name, null: false, index: true
      t.boolean :active, default: true, index: true

      t.timestamps
    end

    add_index :cards, [:card_type, :card_id], name: 'card_type_index'
  end
end
