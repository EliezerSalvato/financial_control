<template>
  <div>
    <Menu />

    <main>
      <transition mode="out-in">
        <router-view />
      </transition>
    </main>
  </div>
</template>

<script>
  import Menu from "./components/Menu.vue";

  export default {
    components: {
      Menu
    }
  }
</script>

<style>
  .v-enter, .v-leave-to {
    opacity: 0;
  }

  .v-enter {
    transform: translate3d(0, -20px, 0);
  }

  .v-leave-to {
    transform: translate3d(0, 20px, 0);
  }

  .v-enter-active, .v-leave-active {
    transition: all 0.3s;
  }
</style>
