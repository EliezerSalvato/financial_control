<template>
  <FormPanel
    type="edit"
    modelName="expense"
    @call:save="save"
  >
    <template #form>
      <Expense
        type="edit"
        :currentErrors="errors"
        :expenseLoaded="expenseLoaded"
        @change:expense="changeExpense"
      />
    </template>
  </FormPanel>
</template>

<script>
  import { api } from "../../services.js";
  import formable from "../../mixins/formable.js";
  import FormPanel from "../../components/FormPanel.vue";
  import Expense from "./form.vue";

  export default {
    name: "Edit",
    mixins: [formable],
    components: {
      FormPanel,
      Expense
    },
    data() {
      return {
        expense: null,
        expenseLoaded: null
      }
    },
    methods: {
      changeExpense(expense) {
        this.expense = expense
      },
      save() {
        const params = {
          description: this.expense.description,
          expense_type: this.expense.expenseType,
          card_id: this.expense.cardId,
          category_id: this.expense.categoryId,
          group_id: this.expense.groupId,
          quantity: this.expense.quantity,
          value: this.expense.value,
          date: this.expense.date,
          end_at: this.expense.endAt,
          expense_recurrents_attributes: this.expense.expenseRecurrents
        }

        api.put(`expenses/${this.$route.params.id}`, params).then(response => {
          if (response["status"] === 200) {
            const message = "Expense was successfully updated.";
            this.setCurrentMessage({ message: message, type: "success" });
            this.$router.push({ path: "/expenses", query: { keepMessage: true } });
          }
        }).catch(error => {
          this.catch_errors(error);

          if (error.response["status"] === 422) {
            this.errors = error.response.data.error;
          }
        });
      }
    },
    created() {
      if (this.$route.params.id) {
        api.get(`expenses/${this.$route.params.id}`).then(response => {
          const result = response.data;
          const expenseRecurrents = result.expense_recurrents.map(expense_recurrent => {
            return {
              id: expense_recurrent.id,
              date: expense_recurrent.date,
              value: Number(expense_recurrent.value),
              _destroy: null
            }
          });

          this.expense = {
            description: result.description,
            expenseType: result.expense_type,
            cardId: result.card_id,
            categoryId: result.category_id,
            groupId: result.group_id,
            endAt: result.end_at,
            expenseRecurrents: expenseRecurrents
          }
          this.expenseLoaded = this.expense;
        }).catch(error => {
          this.catch_errors(error);
        });
      }
    }
  }
</script>

<style scoped>
</style>
