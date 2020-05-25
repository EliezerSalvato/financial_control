class ExpenseTypes < EnumerateIt::Base
  associate_values(
    :card,
    :installment,
    :recurring_installments,
    :recurring_expense,
    :cash
  )

  sort_by :name
end
