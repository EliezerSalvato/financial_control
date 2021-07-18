<template>
  <Board
    type="Expenses"
    type_column="expense_type"
    :items="expenses"
    :currentDate="currentDate"
  />
</template>

<script>
  import fetchable from "../../mixins/fetchable.js";
  import Board from "./board.vue";

  export default {
    name: "Expenses",
    mixins: [fetchable],
    components: {
      Board
    },
    props: {
      currentDate: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        expenses: []
      }
    },
    methods: {
      total() {
        return (this.expenses || []).map(expense => {
          return Number(expense.value)
        }).reduce((sum, value) => sum + value, 0);
      },
      changeTotal() {
        this.$emit("change:total", this.total());
      }
    },
    watch: {
      currentDate: {
        handler() {
          const params = {
            month: this.currentDate.month,
            year: this.currentDate.year,
            loading: true
          }

          this.getWithLoading("dashboard/expenses", params).then(response => {
            this.expenses = response.data;
            this.changeTotal();
          });
        },
        immediate: true
      }
    }
  }
</script>

<style scoped>
  .items {
    grid-area: expenses;
  }
</style>
