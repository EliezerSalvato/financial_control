class MigrateFromGroupsToTags < ActiveRecord::Migration[6.0]
  class MigrationGroup < ActiveRecord::Base
    self.table_name = :groups
  end

  def change
    MigrationGroup.all.each do |group|
      tag = Tag.create!(
        user_id: group.user_id,
        name: group.name
      )

      Income.where(group_id: group.id).each do |income|
        income.tags << tag
        income.save!
      end

      Expense.where(group_id: group.id).each do |expense|
        expense.tags << tag
        expense.save!
      end
    end
  end
end
