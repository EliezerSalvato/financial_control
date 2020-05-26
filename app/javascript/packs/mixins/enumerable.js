const DateFormat = {
  BACK_END: "YYYY-MM-DD",
  FRONT_END: "DD/MM/YYYY"
}
Object.freeze(DateFormat)

const CARD_TYPES = {
  Credit: "Credit"
}
Object.freeze(CARD_TYPES)

const ExpenseTypes = {
  CARD: "card",
  INSTALLMENT: "installment",
  RECURRING_INSTALLMENTS: "recurring_installments",
  RECURRING_EXPENSE: "recurring_expense",
  CASH: "cash",
  values: {
    card: "Card",
    installment: "Installment",
    recurring_installments: "Recurring Installments",
    recurring_expense: "Recurring Expense",
    cash: "Cash"
  }
}
Object.freeze(ExpenseTypes)

const IncomeTypes = {
  SALARY: "salary",
  CASH: "cash",
  values: {
    salary: "Salary",
    cash: "Cash"
  }
}
Object.freeze(IncomeTypes)

export default {
  name: "Enumerable",
  data() {
    return {
      DateFormat,
      CARD_TYPES,
      ExpenseTypes,
      IncomeTypes
    }
  }
}
