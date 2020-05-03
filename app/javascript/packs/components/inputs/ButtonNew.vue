<template>
  <router-link class="button is-primary is-fullwidth" :to="route">
    <i class="fa fa-plus"></i>
    <b class="is-hidden-touch">{{ name }}</b>
  </router-link>
</template>

<script>
  export default {
    name: "ButtonNew",
    props: {
      name: String,
      route: String
    }
  }
</script>

<style scoped>
  b {
    margin-left: 5px;
    text-transform: capitalize;
  }
</style>
