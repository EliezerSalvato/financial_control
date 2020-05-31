<template>
  <Modal
    title="Confirmation"
    :openModal="openModalDelete"
    @close="close"
  >
    <template #body>
      Are you sure you want to remove the {{ modelName }}{{ currentItemName }}?
    </template>
    <template #footer>
      <button class="button is-success" @click="deleteItem">Yes</button>
      <button class="button" @click="close">No</button>
    </template>
  </Modal>
</template>

<script>
  import { mapState, mapActions } from "vuex";
  import Modal from "./Modal.vue";

  export default {
    name: "ModalDelete",
    props: {
      modelName: { type: String, required: true },
      currentItemId: { type: Number, required: true },
      itemName: String
    },
    components: {
      Modal
    },
    computed: {
      ...mapState(["openModalDelete"]),
      currentItemName() {
        return (this.itemName ? ` "${this.itemName}"` : "");
      }
    },
    methods: {
      ...mapActions(["setOpenModalDelete"]),
      close() {
        this.setOpenModalDelete(false);
      },
      deleteItem() {
        this.$emit("delete:item", this.currentItemId);
      }
    }
  }
</script>

<style scoped>
  .modal {
    margin-top: -15%;
  }
</style>
