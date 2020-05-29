class MonthlyIncome < ApplicationRecord
  def self.by_month_and_year(user_id, month, year)
    MonthlyIncome.find_by_sql(
      <<-SQL
        SELECT cards.name AS income_type,
               incomes.description AS description,
               income_recurrents.value AS value,
               income_recurrents.date AS date
          FROM incomes
          JOIN cards
            ON cards.id = incomes.card_id
           AND cards.card_type = 'Credit'
          JOIN income_recurrents
            ON income_recurrents.id = (
                 SELECT income_recurrents.id
                   FROM income_recurrents
                  WHERE income_recurrents.income_id = incomes.id
                    AND income_recurrents.date <= (
                          SELECT closing_date
                            FROM credit_card_by_month(cards.card_id, #{month}, #{year})
                        )
               ORDER BY income_recurrents.date DESC
                  LIMIT 1
               )
         WHERE incomes.user_id = #{user_id}
           AND cards.card_type = 'Credit'
           AND (
                 incomes.end_at IS NULL OR
                 incomes.end_at >= (
                   SELECT opening_date
                     FROM credit_card_by_month(cards.card_id, #{month}, #{year})
                 )
               )
        UNION ALL
        SELECT types.type AS income_type,
               incomes.description AS description,
               income_recurrents.value AS value,
               income_recurrents.date AS date
          FROM incomes
          JOIN income_recurrents
            ON income_recurrents.id = (
                 SELECT income_recurrents.id
                   FROM income_recurrents
                  WHERE income_recurrents.income_id = incomes.id
                    AND income_recurrents.date <= date_trunc(
                          'day', make_date(#{year}, #{month}, 1) + interval '1 month' - interval '1 day'
                        )
               ORDER BY income_recurrents.date DESC
                  LIMIT 1
               )
     LEFT JOIN cards
            ON cards.id = incomes.card_id,
       LATERAL (SELECT CASE
                         WHEN cards.card_type = 'Debit' THEN cards.name
                         WHEN income_type = 'cash' THEN 'Cash'
                       END AS type
               ) AS types
         WHERE incomes.user_id = #{user_id}
           AND types.type IS NOT NULL
           AND (incomes.end_at IS NULL OR incomes.end_at >= make_date(#{year}, #{month}, 1))
      ORDER BY date, description
      SQL
    )
  end
end
