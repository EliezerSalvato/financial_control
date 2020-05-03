<template>
  <label class="checkbox" :for="name" @click="updateValue($event, !value)">
    <input
      type="checkbox"
      v-model="checked"
      :name="name"
      @change="updateValue"
    >
    {{ label }}
  </label>
</template>

<script>
  export default {
    name: "CheckBox",
    props: {
      name: String,
      value: Boolean,
      label: String
    },
    data() {
      return {
        currentValue: null
      }
    },
    computed: {
      checked: {
        get() {
          return this.value
        }
      }
    },
    methods: {
      updateValue(event, value = null) {
        this.$emit("input", (value != null ? value : this.currentValue));
      }
    },
    watch: {
      value(value) {
        this.currentValue = value
      }
    }
  }
</script>

<style scoped>
  .panel-block input[type=checkbox] {
    margin-right: 3px;
  }
</style>
