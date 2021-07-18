class AddKindToMonthlyExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :monthly_expenses, :kind, :string
  end
end
