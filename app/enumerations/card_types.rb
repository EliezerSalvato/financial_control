class CardTypes < EnumerateIt::Base
  associate_values(
    credit: 'Credit'
  )

  sort_by :name
end
