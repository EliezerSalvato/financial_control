class RemoveGroupIdFromExpense < ActiveRecord::Migration[6.0]
  def change
    remove_column :expenses, :group_id, :integer
  end
end
