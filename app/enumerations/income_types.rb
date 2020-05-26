class IncomeTypes < EnumerateIt::Base
  associate_values(
    :salary,
    :cash
  )

  sort_by :name
end
