<template>
  <FormPanel
    type="new"
    modelName="income"
    @call:save="save"
  >
    <template #form>
      <Income
        type="new"
        :currentErrors="errors"
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
    name: "New",
    mixins: [formable],
    components: {
      FormPanel,
      Income
    },
    data() {
      return {
        income: {
          description: null,
          incomeType: null,
          cardId: null,
          categoryId: null,
          quantity: null,
          value: null,
          date: null,
          endAt: null,
          incomeTags: [],
          incomeRecurrents: []
        }
      }
    },
    computed: {
      incomeTagsParams() {
        return this.income.incomeTags.map(incomeTag => {
          return {
            tag_id: incomeTag.tag_id,
            _destroy: incomeTag._destroy
          }
        });
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
          quantity: this.income.quantity,
          value: this.income.value,
          date: this.income.date,
          end_at: this.income.endAt,
          income_tags_attributes: this.incomeTagsParams,
          income_recurrents_attributes: this.income.incomeRecurrents
        }

        api.post("incomes", params).then(response => {
          if (response["status"] === 201) {
            const message = "Income was successfully created.";
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
    }
  }
</script>

<style scoped>
</style>
