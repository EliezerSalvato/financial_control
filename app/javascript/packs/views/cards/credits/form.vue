<template>
  <div class="form">
    <div class="field">
      <div class="control">
        <InputNumeric
          v-model="value.limit"
          name="limit"
          label="Limit"
          :required="true"
          :error="error('card.limit')"
        />
      </div>
    </div>
    <div class="field">
      <div class="control">
        <InputNumeric
          v-model="value.super_limit"
          name="super_limit"
          label="Super Limit"
          :error="error('card.super_limit')"
        />
      </div>
    </div>
    <div class="field">
      <div class="control">
        <InputNumber
          v-model="value.due_day"
          name="due_day"
          label="Due Day"
          :minValue="1"
          :maxValue="31"
          :required="true"
          :error="error('card.due_day')"
        />
      </div>
    </div>
    <div class="field">
      <div class="control">
        <InputNumber
          v-model="value.closing_day"
          name="closing_day"
          label="Closing Day"
          :minValue="1"
          :maxValue="31"
          :required="true"
          :error="error('card.closing_day')"
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
