class AddGoalToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :goal, :decimal
  end
end
