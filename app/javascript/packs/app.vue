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
</style>
