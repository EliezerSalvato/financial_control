<template>
  <div class="select-box">
    <label v-if="label" class="label" :for="name" @click="focus">
      {{ label }}
      <abbr v-if="label && required" title="required">*</abbr>
    </label>
    <span v-if="!currentValue" class="select-placeholder">{{ placeholder }}</span>
    <div class="select is-fullwidth">
      <select
        v-model="currentValue"
        class="input"
        ref="input"
        :class="{ 'is-danger': error }"
        @change="change"
        :disabled="disabled"
      >
        <option value="" default></option>
        <option v-for="{ id, description } in itemsArray" :value="id" :key="id">
          {{ description }}
        </option>
        <option v-for="(text, value) in itemsObject" :value="value" :key="value">
          {{ text }}
        </option>
        <slot />
      </select>
    </div>
    <p class="help is-danger">{{ error }}</p>
  </div>
</template>

<script>
  export default {
    name: "Select",
    props: {
      name: String,
      value: [String, Number],
      label: String,
      error: String,
      placeholder: String,
      items: [Object, Array],
      required: { type: Boolean, default: false },
      disabled: { type: String, default: null }
    },
    data() {
      return {
        currentValue: null
      }
    },
    computed: {
      itemsArray() {
        return (Array.isArray(this.items) ? this.items : []);
      },
      itemsObject() {
        return (!Array.isArray(this.items) ? this.items : {});
      }
    },
    methods: {
      change() {
        this.$emit("input", this.currentValue);
        this.$emit("change:selected", { name: this.name, value: this.currentValue });
      },
      focus() {
        this.$refs.input.focus();
      }
    },
    watch: {
      value() {
        this.currentValue = this.value;
      }
    },
    updated() {
      if (["string", "number"].includes(typeof this.value)) {
        this.currentValue = this.value;
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

  .input {
    box-shadow: inset 0 1px 2px rgba(10, 10, 10, 0.1);
  }

  div select {
    background-color: rgba(0, 0, 0, 0.0);
  }
</style>
