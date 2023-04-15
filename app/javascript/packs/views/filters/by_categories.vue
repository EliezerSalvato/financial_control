<template>
  <Board
    type="Category"
    title="By Categories"
    type_column="category_id"
    :typeItems="typeItems"
    :items="expenses"
    :currentDate="currentDate"
  />
</template>

<script>
  import fetchable from "../../mixins/fetchable.js";
  import Board from "./board.vue";

  export default {
    name: "ByCategories",

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
        expenses: [],
        typeItems: []
      }
    },

    methods: {
    },

    watch: {
      currentDate: {
        async handler() {
          const categoryParams = {
            filter: {
              by_active: true
            },
            show_all: true,
            loading: false
          }

          await this.getWithLoading("categories", categoryParams).then(response => {
            this.typeItems = response.data.data;
          });

          const expenseParams = {
            month: this.currentDate.month,
            year: this.currentDate.year,
            loading: true
          }

          this.getWithLoading("home/expenses", expenseParams).then(response => {
            this.expenses = response.data;
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
