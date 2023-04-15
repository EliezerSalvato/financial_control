<template>
  <div>
    <Loading v-show="showLoading" />

    <div v-show="!showLoading" class="filters">
      <div class="date-chosen buttons has-addons">
        <button class="button" @click="prevDate">‹ Prev</button>
        <button class="button">{{ currentDate.month }}/{{ currentDate.year }}</button>
        <button class="button" @click="nextDate">Next ›</button>
      </div>

      <ByCategories :currentDate="currentDate" />

      <ByTags :currentDate="currentDate" />
    </div>
  </div>
</template>

<script>
  import { mapState } from "vuex";
  import moment from "moment";
  import accountingJs from 'accounting-js';
  import ByCategories from "./by_categories";
  import ByTags from "./by_tags";

  Object.assign(accountingJs.settings, {
    decimal: ",",
    thousand: "."
  });

  export default {
    name: "Filters",
    components: {
      ByCategories,
      ByTags
    },
    data() {
      return {
        date: null,
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
  .filters {
    margin: 10px auto;
    max-width: 800px;
    display: flex;
    flex-direction: column;
  }

  .date-chosen {
    margin: 0 auto !important;
  }
</style>
