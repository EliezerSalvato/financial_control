<template>
  <div class="modal" :class="{ 'is-active': openModal }">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header v-if="title" class="modal-card-head">
        <p class="modal-card-title">{{ title }}</p>
        <button class="delete" @click="close"></button>
      </header>

      <section class="modal-card-body">
        <slot name="body" />
      </section>

      <footer class="modal-card-foot">
        <slot name="footer" />
      </footer>
    </div>
  </div>
</template>

<script>
  export default {
    name: "Modal",
    props: {
      title: String,
      openModal: { type: Boolean, default: false }
    },
    methods: {
      close() {
        this.$emit("close");
      }
    }
  }
</script>

<style scoped>
  .modal-card {
    max-width: calc(100% - 30px);
  }

  .modal-card-foot {
    justify-content: flex-end;
  }
</style>
