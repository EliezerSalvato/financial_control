<template>
  <div>
    <Loading v-show="showLoading" />

    <div v-show="!showLoading" class="dashboard">
      <div class="date-chosen buttons has-addons">
        <button class="button" @click="prevDate">‹ Prev</button>
        <button class="button">{{ currentDate.month }}/{{ currentDate.year }}</button>
        <button class="button" @click="nextDate">Next ›</button>
      </div>

      <Incomes :currentDate="currentDate" @change:total="totalIncome = $event" />
      <Expenses :currentDate="currentDate" @change:total="totalExpense = $event" />
      <div class="box balance">
        <b>Balance:</b>{{ formatValue(totalIncome - totalExpense) }}
      </div>
    </div>
  </div>
</template>

<script>
  import { mapState } from "vuex";
  import moment from "moment";
  import accountingJs from 'accounting-js';
  import Incomes from "./incomes.vue";
  import Expenses from "./expenses.vue";

  Object.assign(accountingJs.settings, {
    decimal: ",",
    thousand: "."
  });

  export default {
    name: "Dashboard",
    components: {
      Incomes,
      Expenses
    },
    data() {
      return {
        date: null,
        totalIncome: null,
        totalExpense: null,
        currentDate: {
          month: null,
          year: null
        }
      }
    },
    computed: mapState(["showLoading"]),
    methods: {
      setCurrentDate() {
        this.currentDate = {
          month: this.date.format("MM"),
          year: this.date.year()
        }
      },
      prevDate() {
        this.date.subtract(1, 'M');
        this.setCurrentDate();
      },
      nextDate() {
        this.date.add(1, 'M');
        this.setCurrentDate();
      },
      formatValue(value) {
        return accountingJs.formatNumber(value);
      }
    },
    created() {
      let now = moment();
      let currentDay = now.date();
      this.date = (currentDay > 10 ? now.add(1, 'M') : now);
      this.setCurrentDate();
    }
  }
</script>

<style scoped>
  .dashboard {
    margin: 0 auto;
    max-width: 1344px;
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 55px 1fr;
    grid-template-areas:
      "date date"
      "incomes expenses"
      "balance balance"
    ;
    align-content: start;
    column-gap: 10px;
  }

  @media (max-width: 1023px) {
    .dashboard {
      margin: 0 10px;
      grid-template-columns: 1fr;
      grid-template-rows: 55px minmax(50px, auto-fit) minmax(50px, auto-fit);
      grid-template-areas:
        "date"
        "balance"
        "expenses"
        "incomes"
      ;
    }
  }

  .date-chosen {
    grid-area: date;
    justify-self: center;
    align-self: end;
    margin: 0 !important;
  }

  .balance {
    grid-area: balance;
    margin-bottom: 10px;
    text-align: center;
    padding: 5px;
  }

  .balance b {
    margin-right: 10px;
  }
</style>
