<template>
  <FormPanel
    type="new"
    modelName="expense"
    @call:save="save"
  >
    <template #form>
      <Expense
        type="new"
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
    name: "New",
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
    computed: {
      expenseTagsParams() {
        return (this.expense.expenseTags || []).map(expenseTag => {
          return {
            tag_id: expenseTag.tag_id,
            _destroy: expenseTag._destroy
          }
        });
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
          quantity: this.expense.quantity,
          value: this.expense.value,
          date: this.expense.date,
          end_at: this.expense.endAt,
          expense_tags_attributes: this.expenseTagsParams,
          expense_recurrents_attributes: this.expense.expenseRecurrents
        }

        api.post("expenses", params).then(response => {
          if (response["status"] === 201) {
            const message = "Expense was successfully created.";
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
      this.getWithLoading(`expenses/last_expense`).then(response => {
        const result = response.data;

        this.expenseLoaded = {
          expenseType: result.expense_type,
          cardId: result.card_id,
          categoryId: result.category_id
        }
      }).catch(error => {
        this.catch_errors(error);
      });
    }
  }
</script>

<style scoped>
</style>
