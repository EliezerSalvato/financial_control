<template>
  <IndexPanel
    modelName="expense"
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
          name="by_expense_type"
          placeholder="Filter by expense type"
          :items="ExpenseTypes.values"
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
      <th class="expense_type is-hidden-mobile">Expense type</th>
      <th class="is-hidden-mobile">Expense date</th>
      <th class="card_name is-hidden-touch">Card</th>
    </template>

    <template #table-item="{ item }">
      <td class="is-hidden-mobile">{{ ExpenseTypes.values[item.expense_type] }}</td>
      <td class="is-hidden-mobile">{{ expenseDate(item) }}</td>
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
      ...mapActions(["setOpenModalDelete", "setCurrentMessage"]),
      getData() {
        this.getWithLoading("expenses", this.currentQuery).then(response => {
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
      expenseDate(item) {
        const dates = item.expense_recurrents.map(
          expenseRecurrent => moment(expenseRecurrent.date, this.DateFormat.BACK_END)
        );

        return moment.min(dates).format(this.DateFormat.FRONT_END);
      },
      deleteItem(itemId) {
        api.delete(`expenses/${itemId}`).then(response => {
          if (response["status"] === 200) {
            const message = "Expense was successfully removed.";
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
  .expense_type {
    min-width: 228px;
  }

  .card_name {
    min-width: 165px;
  }
</style>
