<template>
  <nav class="items panel">
    <div class="panel-heading">
      <p>{{ title }}</p>
    </div>
    <div class="panel-block">
      <table class="table is-bordered is-striped is-hoverable is-fullwidth">
        <thead>
          <tr>
            <th>{{ type }}</th>
            <th>Value</th>
            <th>Goal</th>
            <th>Diff</th>
            <th colspan="2">%</th>
          </tr>
        </thead>

        <tbody>
          <tr v-for="(type, index) in typesWithDisplayItem" :key="index" :class="goalColor(type)">
            <td v-if="type == displayedItem" colspan="6">
              <table class="table is-bordered is-striped is-hoverable is-fullwidth">
                <thead>
                  <tr>
                    <th>Date</th>
                    <th>Description</th>
                    <th>Value</th>
                  </tr>
                </thead>

                <tbody>
                  <tr v-for="(item, index_item) in itemsByType" :key="index_item">
                    <td>{{ formatDate(item.date) }}</td>
                    <td>
                      <router-link :to="routeEdit(item.id)">
                        {{ description(item) }}
                      </router-link>
                    </td>
                    <td>{{ formatValue(item.value) }}</td>
                  </tr>
                </tbody>
              </table>
            </td>
            <td v-if="type != displayedItem">{{ typeById(type).name }}</td>
            <td v-if="type != displayedItem">{{ formatValue(totalByType(type)) }}</td>
            <td v-if="type != displayedItem">{{ formatValue(typeById(type).goal) }}</td>
            <td v-if="type != displayedItem">{{ formatValue(diffTotalVsGoal(type)) }}</td>
            <td v-if="type != displayedItem">{{ formatPercent(percent(type)) }}</td>
            <td v-if="type != displayedItem" class="expand_header">
              <a class="expand" @click="showHideItem(type)">
                <span :class="(type == displayed ? 'minus' : 'plus')"></span>
              </a>
            </td>
          </tr>
        </tbody>

        <tfoot>
          <td v-if="!items.length" colspan="6">No {{ type }} found.</td>
        </tfoot>
      </table>
    </div>
  </nav>
</template>

<script>
  import moment from "moment";
  import accountingJs from 'accounting-js';
  import enumerable from "../../mixins/enumerable.js";

  Object.assign(accountingJs.settings, {
    decimal: ",",
    thousand: "."
  });

  export default {
    name: "Board",

    mixins: [enumerable],

    props: {
      type: String,
      title: String,
      type_column: String,
      typeItems: Array,
      items: Array,
      currentDate: {
        type: Object,
        required: true
      }
    },

    data() {
      return {
        displayed: null
      }
    },

    computed: {
      displayedItem() {
        return `${this.displayed}_items`;
      },
      types() {
        return Array.from(new Set((this.items || []).map(item => item[this.type_column]).flat())).filter(Boolean);
      },
      typesWithNames() {
        return this.types.map(type => this.typeById(type)).sort((a, b) => a.name.localeCompare(b.name)).map(item => item.id);
      },
      typesWithItems() {
        return this.typesWithNames.map(type => [type, `${type}_items`]).flat(1);
      },
      typesWithDisplayItem() {
        return this.typesWithItems.filter(item => {
          return this.types.includes(item) || item == this.displayedItem
        });
      },
      itemsByType() {
        return this.items.filter(item => [item[this.type_column]].flat().includes(this.displayed));
      },
      routeNew() {
        return `/${this.type.toLowerCase()}/new`;
      }
    },

    methods: {
      formatDate(date) {
        return moment(date, this.DateFormat.BACK_END).format(this.DateFormat.FRONT_END);
      },
      formatValue(value) {
        return !value ? '' : accountingJs.formatNumber(value);
      },
      formatPercent(value) {
        return !value ? '' : `${accountingJs.formatNumber(value)}%`;
      },
      typeById(id) {
        const type = this.typeItems.find(item => item.id == id );

        if (!type) return {};

        return {
          id: id,
          name: type.name,
          goal: type.goal
        }
      },
      totalByType(type) {
        return (this.items || []).map(item => {
          return ([item[this.type_column]].flat().includes(type) ? Number(item.value) : 0)
        }).reduce((sum, value) => sum + value, 0);
      },
      diffTotalVsGoal(type) {
        const goal = this.typeById(type).goal;
        return !goal ? '' : goal - this.totalByType(type);
      },
      percent(type) {
        const goal = this.typeById(type).goal;
        return !goal ? '' : ((this.totalByType(type) / goal) * 100);
      },
      showHideItem(type) {
        this.displayed = (this.displayed == type ? null : type);
      },
      routeEdit(id) {
        return `/expenses/edit/${id}`;
      },
      goalColor(type) {
        const percent = this.percent(type);
        return (percent < 80 ? '' : (percent < 100 ? 'goal-color-warning' : 'goal-color-danger'));
      },
      description(item) {
        let description = item.description;

        if ([this.ExpenseTypes.INSTALLMENT, this.ExpenseTypes.RECURRING_INSTALLMENTS].includes(item.kind)) {
          const startDate = moment(item.date, this.DateFormat.BACK_END);
          const endDate = moment(item.end_at, this.DateFormat.BACK_END);
          const currentDate = moment(
            `${this.currentDate.year}-${this.currentDate.month}-${startDate.date()}`,
            this.DateFormat.BACK_END
          );
          const totalDiff = endDate.diff(startDate, 'months') + 1;
          const currentDiff = currentDate.diff(startDate, 'months');

          description = `${description} - ${currentDiff}/${totalDiff}`
        }

        return description;
      }
    }
  }
</script>

<style scoped>
  .panel-block {
    padding: 5px !important;
  }

  .panel-heading {
    display: flex;
    justify-content: flex-end;
    align-content: center;
  }

  .panel-heading p {
    flex-grow: 1;
    align-self: center;
  }

  .panel-heading a {
    flex-grow: 0;
  }

  .expand_header {
    width: 1px;
  }

  .expand {
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #3273dc;
    color: white;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    font-weight: bold;
  }

  .expand span {
    margin-top: -2px;
  }

  @media (max-width: 768px) {
    .expand span {
      margin-top: 0;
      margin-left: -1px;
    }
  }

  .plus::before {
    content: '+'
  }

  .minus::before {
    content: '-'
  }

  table td {
    overflow: hidden;
    padding: 5px;
  }

  .goal-color-warning {
    background-color: #FFFBEB !important;
  }

  .goal-color-warning:hover {
    background-color: #FAF6E6 !important;
  }

  .goal-color-danger {
    background-color: #FEECF0 !important;
  }

  .goal-color-danger:hover {
    background-color: #F2E1E5 !important;
  }
</style>
