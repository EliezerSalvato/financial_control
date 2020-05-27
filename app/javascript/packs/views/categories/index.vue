<template>
  <IndexPanel
    modelName="category"
    :items="items"
    :paginatable="paginatable"
    @change:page="changePage"
    @delete:item="deleteItem"
  >
    <template #table-filters>
      <td>
        <InputText name="by_name" placeholder="Filter by name" @change:value="filterChange" />
      </td>
      <td class="is-hidden-mobile">
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
      <th class="active is-hidden-mobile">Active</th>
    </template>

    <template #table-item="{ item }">
      <td class="is-hidden-mobile">{{ item.active ? "Yes" : "No" }}</td>
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
        this.getWithLoading("categories", this.currentQuery).then(response => {
          const result = response.data;
          this.items = result.data;
          this.paginatable = result.paginatable;
        });
      },
      deleteItem(itemId) {
        api.delete(`categories/${itemId}`).then(response => {
          if (response["status"] === 200) {
            const message = "Category was successfully removed.";
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
  .active {
    min-width: 175px;
  }
</style>
