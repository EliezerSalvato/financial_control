class ExpenseTypes < EnumerateIt::Base
  associate_values(
    :card,
    :installment,
    :recurring_installments,
    :card_recurring_expense,
    :cash,
    :cash_recurring_expense
  )

  sort_by :name
end
