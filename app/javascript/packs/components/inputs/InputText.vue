<template>
  <div>
    <label v-if="label" class="label required" :for="name" @click="focus">
      {{ label }}
      <abbr v-if="label && required" title="required">*</abbr>
    </label>
    <input
      type="text"
      ref="input"
      class="input"
      :name="name"
      :value="value"
      :placeholder="placeholder"
       :class="{ 'is-danger': error }"
      @input="updateValue"
    />
    <p class="help is-danger">{{ error }}</p>
  </div>
</template>

<script>
  export default {
    name: "InputText",
    props: {
      name: String,
      value: String,
      label: String,
      error: String,
      placeholder: String,
      required: { type: Boolean, default: false }
    },
    methods: {
      updateValue(event) {
        const value = event.target.value;
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
