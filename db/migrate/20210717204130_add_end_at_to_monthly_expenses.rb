class AddEndAtToMonthlyExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :monthly_expenses, :end_at, :date
  end
end
