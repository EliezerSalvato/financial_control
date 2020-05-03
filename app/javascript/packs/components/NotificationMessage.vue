<template>
  <div v-if="currentMessage" class="notification" :class="classType">
    <button class="delete" @click="close"></button>
    <p>
      <i class="fas" :class="iconType"></i>
      {{ currentMessage }}
    </p>
  </div>
</template>

<script>
  import { mapState, mapActions } from "vuex";

  export default {
    name: "NotificationMessage",
    props: {
      type: { type: String }
    },
    data() {
      return {
        defaultType: "danger"
      }
    },
    computed: {
      ...mapState(["currentMessage"]),
      currentType() {
        return (this.type || this.defaultType);
      },
      classType() {
        return 'is-' + this.currentType;
      },
      iconType() {
        return (this.currentType == this.defaultType ? "fa-times" : "fa-check");
      }
    },
    methods: {
      ...mapActions(["setCurrentMessage"]),
      close() {
        this.setCurrentMessage("");
      }
    }
  }
</script>

<style scoped>
</style>
