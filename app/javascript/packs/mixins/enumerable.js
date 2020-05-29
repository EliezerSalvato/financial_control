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
  CARD: "card",
  SALARY: "salary",
  CASH: "cash",
  values: {
    card: "Card",
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
      ActivationTypes,
      CardTypes,
      ExpenseTypes,
      IncomeTypes
    }
  }
}
