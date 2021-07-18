class AddEndAtToMonthlyIncomes < ActiveRecord::Migration[6.0]
  def change
    add_column :monthly_incomes, :end_at, :date
  end
end
