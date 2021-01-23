class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false, index: true
      t.boolean :active, default: true, index: true

      t.timestamps
    end
  end
end
