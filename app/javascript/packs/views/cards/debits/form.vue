<template>
  <div class="form">
    <div class="field">
      <div class="control">
        <InputNumeric
          v-model="value.current_money"
          name="current_money"
          label="Current Money"
          :required="true"
          :error="error('card.current_money')"
        />
      </div>
    </div>
  </div>
</template>

<script>
  import inputable from "../../../mixins/inputable.js";

  export default {
    name: "Form",
    mixins: [inputable],
    props: {
      value: {
        type: Object,
        required: true
      },
      form_errors: Object
    },
    watch: {
      form_errors(value) {
        this.errors = value;
      }
    }
  }
</script>

<style scoped>
  .form {
    margin-bottom: 10px;
  }
</style>
