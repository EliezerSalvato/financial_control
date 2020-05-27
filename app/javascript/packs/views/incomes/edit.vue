<template>
  <FormPanel
    type="edit"
    modelName="income"
    @call:save="save"
  >
    <template #form>
      <Income
        type="edit"
        :currentErrors="errors"
        :incomeLoaded="incomeLoaded"
        @change:income="changeIncome"
      />
    </template>
  </FormPanel>
</template>

<script>
  import { api } from "../../services.js";
  import formable from "../../mixins/formable.js";
  import FormPanel from "../../components/FormPanel.vue";
  import Income from "./form.vue";

  export default {
    name: "Edit",
    mixins: [formable],
    components: {
      FormPanel,
      Income
    },
    data() {
      return {
        income: null,
        incomeLoaded: null
      }
    },
    methods: {
      changeIncome(income) {
        this.income = income
      },
      save() {
        const params = {
          description: this.income.description,
          income_type: this.income.incomeType,
          card_id: this.income.cardId,
          category_id: this.income.categoryId,
          group_id: this.income.groupId,
          quantity: this.income.quantity,
          value: this.income.value,
          date: this.income.date,
          end_at: this.income.endAt,
          income_recurrents_attributes: this.income.incomeRecurrents
        }

        api.put(`incomes/${this.$route.params.id}`, params).then(response => {
          if (response["status"] === 200) {
            const message = "Income was successfully updated.";
            this.setCurrentMessage({ message: message, type: "success" });
            this.$router.push({ path: "/incomes", query: { keepMessage: true } });
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
        this.getWithLoading(`incomes/${this.$route.params.id}`).then(response => {
          const result = response.data;
          const incomeRecurrents = result.income_recurrents.map(income_recurrent => {
            return {
              id: income_recurrent.id,
              date: income_recurrent.date,
              value: Number(income_recurrent.value),
              _destroy: null
            }
          });

          this.incomeLoaded = {
            description: result.description,
            incomeType: result.income_type,
            cardId: result.card_id,
            categoryId: result.category_id,
            groupId: result.group_id,
            endAt: result.end_at,
            incomeRecurrents: incomeRecurrents
          }
        }).catch(error => {
          this.catch_errors(error);
        });
      }
    }
  }
</script>

<style scoped>
</style>
