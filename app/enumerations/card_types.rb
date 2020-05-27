class CardTypes < EnumerateIt::Base
  associate_values(
    credit: 'Credit',
    debit: 'Debit'
  )

  sort_by :name
end
