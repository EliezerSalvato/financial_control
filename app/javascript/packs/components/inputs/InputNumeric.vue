<template>
  <div>
    <label v-if="label" class="label" :for="name" @click="focus">
      {{ label }}
      <abbr v-if="label && required" title="required">*</abbr>
    </label>
    <input
      type="text"
      ref="input"
      class="input"
      :name="name"
      :value="formattedValue"
      :maxlength="maxLength"
      :placeholder="placeholder"
      :class="{ 'is-danger': error }"
      @input="updateValue"
    />
    <p class="help is-danger">{{ error }}</p>
  </div>
</template>

<script>
  import accountingJs from 'accounting-js';

  Object.assign(accountingJs.settings, {
    decimal: ",",
    thousand: "."
  });

  export default {
    name: "InputNumber",
    props: {
      name: String,
      value: Number,
      label: String,
      error: String,
      placeholder: String,
      required: { type: Boolean, default: false },
      maxLength: { type: Number, default: 14 }
    },
    computed: {
      formattedValue() {
        return (this.value == null ? null : accountingJs.formatNumber(this.value));
      }
    },
    methods: {
      isNumber(event, value) {
        if (event instanceof InputEvent && !event.inputType.includes("delete")) {
          if (isNaN(Number(value))) { return false }
        }

        if ([".", ","].includes(event.data)) { return false }

        return true;
      },
      numericValue(value) {
        value = value.replace(/[^\d]/g, "").padStart(3, 0);
        return Number(`${value.slice(0, value.length - 2)}.${value.slice(value.length - 2)}`);
      },
      updateValue(event) {
        let value = event.target.value;
        value = value.replace(/[.,]/g, "");

        if (!this.isNumber(event, value)) {
          event.target.value = this.formattedValue;
          return;
        }

        if (value != "") {
          value = this.numericValue(value);
        } else {
          value = null;
        }

        this.$emit("input", value);
        this.$emit("change:value", { name: this.name, value: value });
      },
      focus() {
        this.$refs.input.focus();
      }
    }
  }
</script>

<style scoped>
</style>
