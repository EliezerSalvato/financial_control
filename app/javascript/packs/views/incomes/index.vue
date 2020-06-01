<template>
  <IndexPanel
    modelName="income"
    :items="items"
    :paginatable="paginatable"
    @change:page="changePage"
    @delete:item="deleteItem"
  >
    <template #table-filters>
      <td>
        <InputText name="by_description" placeholder="Filter by description" @change:value="filterChange" />
      </td>
      <td class="is-hidden-mobile">
        <Select
          name="by_income_type"
          placeholder="Filter by income type"
          :items="IncomeTypes.values"
          @change:selected="filterChange"
        />
      </td>
      <td class="is-hidden-mobile"></td>
      <td class="is-hidden-touch">
        <Select
          name="by_card_id"
          placeholder="Filter by card"
          :items="cards"
          @change:selected="filterChange"
        />
      </td>
    </template>

    <template #table-header>
      <th>Description</th>
      <th class="income_type is-hidden-mobile">Income type</th>
      <th class="is-hidden-mobile">Income date</th>
      <th class="card_name is-hidden-touch">Card</th>
    </template>

    <template #table-item="{ item }">
      <td class="is-hidden-mobile">{{ IncomeTypes.values[item.income_type] }}</td>
      <td class="is-hidden-mobile">{{ incomeDate(item) }}</td>
      <td class="is-hidden-touch">{{ item.card && item.card.name }}</td>
    </template>
  </IndexPanel>
</template>

<script>
  import moment from "moment";
  import { mapActions } from "vuex";
  import { api } from "../../services.js";
  import indexable from "../../mixins/indexable.js";
  import IndexPanel from "../../components/IndexPanel.vue";

  export default {
    mixins: [indexable],
    components: {
      IndexPanel
    },
    data() {
      return {
        cards: null
      }
    },
    computed: {
      defaultQuery() {
        return {
          filter: {
            by_active: true
          },
          show_all: true
        }
      }
    },
    methods: {
      ...mapActions(["setOpenModalDelete", "setCurrentMessage", "setShowLoading"]),
      getData() {
        this.getWithLoading("incomes", this.currentQuery).then(response => {
          const result = response.data;
          this.items = result.data;
          this.paginatable = result.paginatable;
        });
      },
      getCards() {
        api.get("cards", this.defaultQuery).then(response => {
          const result = response.data;
          this.cards = result.data;
        });
      },
      incomeDate(item) {
        const dates = item.income_recurrents.map(
          incomeRecurrent => moment(incomeRecurrent.date, this.DateFormat.BACK_END)
        );

        return moment.min(dates).format(this.DateFormat.FRONT_END);
      },
      deleteItem(itemId) {
        api.delete(`incomes/${itemId}`).then(response => {
          if (response["status"] === 200) {
            const message = "Income was successfully removed.";
            this.setCurrentMessage({ message: message, type: "success" });
            this.setOpenModalDelete(false);
            this.getData();
            this.changePage(1);
          }
        }).catch(error => {
          this.catch_errors(error);
          this.setOpenModalDelete(false);
        });
      }
    },
    created() {
      this.getCards();
    }
  }
</script>

<style scoped>
  .income_type {
    min-width: 220px;
  }

  .card_name {
    min-width: 165px;
  }
</style>
