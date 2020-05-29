class IncomeTypes < EnumerateIt::Base
  associate_values(
    :card,
    :salary,
    :cash
  )

  sort_by :name
end
