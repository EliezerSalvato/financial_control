<template>
  <div class="select-box">
    <span v-if="!currentValue" class="select-placeholder">{{ placeholder }}</span>
    <div class="select is-fullwidth">
      <select v-model="currentValue" @change="change">
        <option value="" default></option>
        <option v-for="(text, value) in items" :value="value" :key="value">
          {{ text }}
        </option>
        <slot />
      </select>
    </div>
  </div>
</template>

<script>
  export default {
    name: "Select",
    props: {
      name: String,
      placeholder: String,
      items: Object
    },
    data() {
      return {
        currentValue: null
      }
    },
    methods: {
      change() {
        this.$emit("change:selected", { name: this.name, value: this.currentValue });
      }
    }
  }
</script>

<style scoped>
  .select-box {
    position: relative;
  }

  .select-placeholder {
    position: absolute;
    color: #ccc;
    margin-top: 6px;
    margin-left: 9px;
  }

  div select {
    background-color: rgba(0, 0, 0, 0.0);
  }
</style>
