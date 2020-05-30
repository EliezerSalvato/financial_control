<template>
  <nav class="items panel">
    <div class="panel-heading">
      <p>{{ type }}</p>
      <router-link class="button is-primary" :to="route">
        <i class="fa fa-plus"></i>
      </router-link>
    </div>
    <div class="panel-block">
      <table class="table is-bordered is-striped is-hoverable is-fullwidth">
        <thead>
          <tr>
            <th>Card/Type</th>
            <th colspan="2">Value</th>
          </tr>
        </thead>

        <tbody>
          <tr v-for="(type, index) in typesWithDisplayItem" :key="index">
            <td v-if="type == displayedItem" colspan="3">
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
                    <td>{{ item.description }}</td>
                    <td>{{ formatValue(item.value) }}</td>
                  </tr>
                </tbody>
              </table>
            </td>
            <td v-if="type != displayedItem">{{ type }}</td>
            <td v-if="type != displayedItem">{{ formatValue(totalByType(type)) }}</td>
            <td v-if="type != displayedItem" class="expand_header">
              <a class="expand" @click="showHideItem(type)">
                <span :class="(type == displayed ? 'minus' : 'plus')"></span>
              </a>
            </td>
          </tr>
        </tbody>

        <tfoot>
          <td v-if="!items.length" colspan="3">No {{ type }} found.</td>
          <td v-if="items.length">
            <b>Total</b>
          </td>
          <td v-if="items.length" colspan="2">
            {{ formatValue(total) }}
          </td>
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
      type_column: String,
      items: Array
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
        return Array.from(new Set((this.items || []).map(item => item[this.type_column])));
      },
      typesWithItems() {
        return this.types.map(type => [type, `${type}_items`]).flat(1);
      },
      typesWithDisplayItem() {
        return this.typesWithItems.filter(item => {
          return this.types.includes(item) || item == this.displayedItem
        });
      },
      itemsByType() {
        return this.items.filter(item => item[this.type_column] == this.displayed);
      },
      total() {
        return (this.items || []).map(item => {
          return Number(item.value)
        }).reduce((sum, value) => sum + value, 0);
      },
      route() {
        return `/${this.type.toLowerCase()}/new`;
      }
    },
    methods: {
      formatDate(date) {
        return moment(date, this.DateFormat.BACK_END).format(this.DateFormat.FRONT_END);
      },
      formatValue(value) {
        return accountingJs.formatNumber(value);
      },
      totalByType(type) {
        return (this.items || []).map(item => {
          return (item[this.type_column] == type ? Number(item.value) : 0)
        }).reduce((sum, value) => sum + value, 0);
      },
      showHideItem(type) {
        this.displayed = (this.displayed == type ? null : type);
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
    margin-top: 0;
  }

  .plus::before {
    content: '+'
  }

  .minus::before {
    content: '-'
  }
</style>
