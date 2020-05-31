const DateFormat = {
  BACK_END: "YYYY-MM-DD",
  FRONT_END: "DD/MM/YYYY"
}
Object.freeze(DateFormat)

const ActivationTypes = {
  ACTIVE: true,
  INACTIVE: false,
  values: {
    "true": "Active",
    "false": "Inactive"
  }
}
Object.freeze(ActivationTypes)

const CardTypes = {
  CREDIT: "Credit",
  DEBIT: "Debit",
  values: {
    Credit: "Credit",
    Debit: "Debit"
  }
}
Object.freeze(CardTypes)

const ExpenseTypes = {
  CARD: "card",
  INSTALLMENT: "installment",
  RECURRING_INSTALLMENTS: "recurring_installments",
  CARD_RECURRING_EXPENSE: "card_recurring_expense",
  CASH: "cash",
  CASH_RECURRING_EXPENSE: "cash_recurring_expense",
  values: {
    card: "Card",
    installment: "Installment",
    recurring_installments: "Recurring Installments",
    card_recurring_expense: "Card Recurring Expense",
    cash: "Cash",
    cash_recurring_expense: "Cash Recurring Expense"
  }
}
Object.freeze(ExpenseTypes)

const IncomeTypes = {
  CARD: "card",
  CARD_RECURRING_INCOME: "card_recurring_income",
  CASH: "cash",
  CASH_RECURRING_INCOME: "cash_recurring_income",
  values: {
    card: "Card",
    card_recurring_income: "Card Recurring Income",
    cash: "Cash",
    cash_recurring_income: "Cash Recurring Income"
  }
}
Object.freeze(IncomeTypes)

export default {
  name: "Enumerable",
  data() {
    return {
      DateFormat,
      ActivationTypes,
      CardTypes,
      ExpenseTypes,
      IncomeTypes
    }
  }
}
