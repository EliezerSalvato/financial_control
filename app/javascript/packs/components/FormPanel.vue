<template>
  <div class="columns is-fullheight">
    <Loading v-if="showLoading" />

    <div v-else class="column">
      <NotificationMessage />

      <nav class="panel">
        <p class="panel-heading">
          {{ type }} {{ modelName }}
        </p>

        <div class="panel-block">
          <form class="form">
            <slot name="form" />

            <div class="field">
              <input type="submit" value="Save" class="button is-link" @click.prevent="save">
              <router-link class="button" :to="`/${pluralizedName}`">Back</router-link>
            </div>
          </form>
        </div>
      </nav>
    </div>
  </div>
</template>

<script>
  import { mapState } from "vuex";
  import pluralize from 'pluralize';
  import NotificationMessage from "./NotificationMessage.vue";

  export default {
    name: "FormPanel",
    components: {
      NotificationMessage
    },
    props: {
      type: String,
      modelName: String
    },
    computed: {
      ...mapState(["showLoading"]),
      pluralizedName() {
        return pluralize(this.modelName);
      }
    },
    methods: {
      save() {
        this.$emit("call:save");
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

  .form {
    flex: 1;
  }
</style>
