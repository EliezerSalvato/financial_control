<template>
  <div>
    <label v-if="label" class="label" :for="name" @click="focus">
      {{ label }}
      <abbr v-if="label && required" title="required">*</abbr>
    </label>
    <input
      type="number"
      ref="input"
      class="input"
      :name="name"
      :value="value"
      :min="minValue"
      :max="maxValue"
      :maxlength="maxLength"
      :placeholder="placeholder"
      :class="{ 'is-danger': error }"
      @input="updateValue"
    />
    <p class="help is-danger">{{ error }}</p>
  </div>
</template>

<script>
  export default {
    name: "InputNumber",
    props: {
      name: String,
      value: Number,
      label: String,
      error: String,
      placeholder: String,
      minValue: Number,
      maxValue: Number,
      required: { type: Boolean, default: false },
      maxLength: { type: Number, default: 2 }
    },
    methods: {
      isNumber(event, value) {
        if (event instanceof InputEvent && !event.inputType.includes("delete")) {
          if (isNaN(event.target.valueAsNumber)) { return false }
        }

        if (value.length > this.maxLength) { return false }
        if ((this.maxValue != null && value > this.maxValue)) { return false }
        if ((this.minValue != null && value != "" && value < this.minValue)) { return false }

        return true;
      },
      updateValue(event) {
        let value = event.target.value;

        if (!this.isNumber(event, value)) {
          event.target.value = this.value;
          return;
        }

        if (!!value) {
          value = Number(value);
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
