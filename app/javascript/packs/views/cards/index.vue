<template>
  <IndexPanel
    modelName="card"
    :items="items"
    :paginatable="paginatable"
    @change:page="changePage"
    @delete:item="deleteItem"
  >
    <template #table-filters>
      <td>
        <InputText name="by_name" placeholder="Filter by name" @change:value="filterChange" />
      </td>
      <td class="is-hidden-touch">
        <Select
          name="by_active"
          placeholder="Filter by active"
          :items="ActivationTypes.values"
          @change:selected="filterChange"
        />
      </td>
    </template>

    <template #table-header>
      <th>Name</th>
      <th class="is-hidden-touch">Active</th>
    </template>

    <template #table-item="{ item }">
      <td class="is-hidden-touch">{{ item.active ? "Yes" : "No" }}</td>
    </template>
  </IndexPanel>
</template>

<script>
  import { mapActions } from "vuex";
  import { api } from "../../services.js";
  import indexable from "../../mixins/indexable.js";
  import IndexPanel from "../../components/IndexPanel.vue";

  export default {
    mixins: [indexable],
    components: {
      IndexPanel
    },
    methods: {
      ...mapActions(["setOpenModalDelete", "setCurrentMessage"]),
      getData() {
        api.get("cards", this.currentQuery).then(response => {
          const result = response.data;
          this.items = result.data;
          this.paginatable = result.paginatable;
        });
      },
      deleteItem(itemId) {
        api.delete(`cards/${itemId}`).then(response => {
          if (response["status"] === 200) {
            const message = "Card was successfully removed.";
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
    }
  }
</script>

<style scoped>
</style>
