<template>
  <div class="columns is-fullheight">
    <div class="column">
      <NotificationMessage />

      <nav class="panel">
        <p class="panel-heading">
          {{ pluralizedName }}
        </p>
        <div class="panel-block">
          <table class="table is-bordered is-striped is-hoverable is-fullwidth">
            <thead>
              <tr>
                <slot name="table-filters" />
                <td>
                  <ButtonNew :name="`new ${modelName}`" :route="`/${pluralizedName}/new`" />
                </td>
              </tr>
              <tr>
                <slot name="table-header" />
                <th class="actions"></th>
              </tr>
            </thead>

            <tbody>
              <tr v-for="item in items" :key="item.id">
                <td>
                  <router-link :to="`/${pluralizedName}/edit/${item.id}`">
                    {{ item.description }}
                  </router-link>
                </td>

                <slot name="table-item" :item="item" />

                <td class="actions">
                  <slot name="table-item-actions" :item="item" />
                  <a class="delete is-large" @click="openModalDelete(item)"></a>
                </td>
              </tr>

              <slot name="table-body" />

              <ModalDelete
                :modelName="modelName"
                :currentItemId="itemIdToDelete"
                :itemName="itemNameToDelete"
                @delete:item="deleteItem"
              />
            </tbody>

            <tfoot>
              <td colspan="99">
                <Paginator :paginatable="paginatable" @change:page="changePage" />
              </td>
            </tfoot>
          </table>
        </div>
      </nav>
    </div>
  </div>
</template>

<script>
  import { mapActions } from "vuex";
  import pluralize from 'pluralize';
  import NotificationMessage from "./NotificationMessage.vue";
  import ButtonNew from "./inputs/ButtonNew.vue";
  import Paginator from "./Paginator.vue";
  import ModalDelete from "./ModalDelete.vue";

  export default {
    name: "IndexPanel",
    components: {
      NotificationMessage,
      ButtonNew,
      Paginator,
      ModalDelete
    },
    props: {
      modelName: String,
      items: Array,
      paginatable: Object
    },
    data() {
      return {
        itemIdToDelete: 0,
        itemNameToDelete: null
      }
    },
    computed: {
      pluralizedName() {
        return pluralize(this.modelName);
      }
    },
    methods: {
      ...mapActions(["setOpenModalDelete"]),
      changePage(page) {
        this.$emit("change:page", page);
      },
      openModalDelete(item) {
        this.itemIdToDelete = item.id;
        this.itemNameToDelete = item.name;
        this.setOpenModalDelete(true);
      },
      deleteItem(itemId) {
        this.$emit("delete:item", itemId);
      }
    }
  }
</script>

<style scoped>
  .columns {
    margin: 0 auto;
    max-width: 1344px;
  }

  .panel-heading {
    text-transform: capitalize;
  }

  .actions {
    width: 1%;
    text-align: center;
  }
</style>
