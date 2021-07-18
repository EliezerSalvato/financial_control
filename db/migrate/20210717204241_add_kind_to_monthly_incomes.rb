class AddKindToMonthlyIncomes < ActiveRecord::Migration[6.0]
  def change
    add_column :monthly_incomes, :kind, :string
  end
end
