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
      <td class="is-hidden-touch">
        <Select
          name="by_card_id"
          placeholder="Filter by card"
          :items="cards"
          @change:selected="filterChange"
        />
      </td>
      <td class="is-hidden-touch"></td>
    </template>

    <template #table-header>
      <th>Description</th>
      <th class="is-hidden-touch">Card</th>
      <th class="is-hidden-touch">Purchase Date</th>
    </template>

    <template #table-item="{ item }">
      <td class="is-hidden-touch">{{ item.card.name }}</td>
      <td class="is-hidden-touch">{{ purchaseDate(item) }}</td>
    </template>
  </IndexPanel>
</template>

<script>
  import moment from "moment";
  import { mapActions } from "vuex";
  import { api } from "../../services.js";
  import indexable from "../../mixins/indexable.js";
  import enumerable from "../../mixins/enumerable.js";
  import IndexPanel from "../../components/IndexPanel.vue";

  export default {
    mixins: [indexable, enumerable],
    components: {
      IndexPanel
    },
    data() {
      return {
        cards: null
      }
    },
    methods: {
      ...mapActions(["setOpenModalDelete", "setCurrentMessage"]),
      getData() {
        api.get("expenses", this.currentQuery).then(response => {
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
      purchaseDate(item) {
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
</style>
