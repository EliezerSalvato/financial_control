<template>
  <Board
    type="Incomes"
    type_column="income_type"
    :items="incomes"
    :currentDate="currentDate"
  />
</template>

<script>
  import { api } from "../../services.js";
  import Board from "./board.vue";

  export default {
    name: "Incomes",
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
        incomes: []
      }
    },
    methods: {
      total() {
        return (this.incomes || []).map(income => {
          return Number(income.value)
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
            year: this.currentDate.year
          }

          api.get("dashboard/incomes", params).then(response => {
            this.incomes = response.data;
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
    grid-area: incomes;
  }

  @media (max-width: 1023px) {
    .items {
      margin-top: -12px;
      margin-bottom: 5px !important;
    }
  }
</style>
