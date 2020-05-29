class MonthlyExpense < ApplicationRecord
  def self.by_month_and_year(user_id, month, year)
    MonthlyExpense.find_by_sql(
      <<-SQL
        SELECT cards.name AS expense_type,
               expenses.description AS description,
               expense_recurrents.value AS value,
               expense_recurrents.date AS date
          FROM expenses
          JOIN cards
            ON cards.id = expenses.card_id
           AND cards.card_type = 'Credit'
          JOIN expense_recurrents
            ON expense_recurrents.id = (
                 SELECT expense_recurrents.id
                   FROM expense_recurrents
                  WHERE expense_recurrents.expense_id = expenses.id
                    AND expense_recurrents.date <= (
                          SELECT closing_date
                            FROM credit_card_by_month(cards.card_id, #{month}, #{year})
                        )
               ORDER BY expense_recurrents.date DESC
                  LIMIT 1
               )
         WHERE expenses.user_id = #{user_id}
           AND cards.card_type = 'Credit'
           AND (
                 expenses.end_at IS NULL OR
                 expenses.end_at >= (
                   SELECT opening_date
                     FROM credit_card_by_month(cards.card_id, #{month}, #{year})
                 )
               )
        UNION ALL
        SELECT types.type AS expense_type,
               expenses.description AS description,
               expense_recurrents.value AS value,
               expense_recurrents.date AS date
          FROM expenses
          JOIN expense_recurrents
            ON expense_recurrents.id = (
                 SELECT expense_recurrents.id
                   FROM expense_recurrents
                  WHERE expense_recurrents.expense_id = expenses.id
                    AND expense_recurrents.date <= date_trunc(
                          'day', make_date(#{year}, #{month}, 1) + interval '1 month' - interval '1 day'
                        )
               ORDER BY expense_recurrents.date DESC
                  LIMIT 1
               )
     LEFT JOIN cards
            ON cards.id = expenses.card_id,
       LATERAL (SELECT CASE
                         WHEN cards.card_type = 'Debit' THEN cards.name
                         WHEN expense_type = 'cash' THEN 'Cash'
                       END AS type
               ) AS types
         WHERE expenses.user_id = #{user_id}
           AND types.type IS NOT NULL
           AND (expenses.end_at IS NULL OR expenses.end_at >= make_date(#{year}, #{month}, 1))
      ORDER BY date, description
      SQL
    )
  end
end
