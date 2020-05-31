class IncomeTypes < EnumerateIt::Base
  associate_values(
    :card,
    :card_recurring_income,
    :cash,
    :cash_recurring_income
  )

  sort_by :name
end
