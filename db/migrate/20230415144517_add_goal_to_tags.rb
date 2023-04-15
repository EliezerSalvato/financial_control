class AddGoalToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :goal, :decimal
  end
end
