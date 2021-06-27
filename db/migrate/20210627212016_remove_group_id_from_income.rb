class RemoveGroupIdFromIncome < ActiveRecord::Migration[6.0]
  def change
    remove_column :incomes, :group_id, :integer
  end
end
