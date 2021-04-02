class CreateIncomeTags < ActiveRecord::Migration[6.0]
  def change
    create_table :income_tags do |t|
      t.references :income, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
