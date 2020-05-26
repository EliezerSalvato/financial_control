<template>
  <nav class="panel">
    <p class="panel-heading">
      Recurrence
    </p>
    <div class="panel-block">
      <table class="table is-bordered is-striped is-hoverable is-fullwidth">
        <thead>
          <tr>
            <th class="date-th">Date</th>
            <th>Value</th>
            <th class="actions">
              <a class="button is-primary is-fullwidth" @click="addRecurrence">
                <i class="fa fa-plus"></i>
                <b class="is-hidden-touch">New Recurrence</b>
              </a>
            </th>
          </tr>
        </thead>

        <tbody>
          <tr v-for="(item, index) in activeItems" :key="index">
            <td>
              <Calendar
                v-model="item.date"
                name="date"
                :withDefaultDate="true"
                :canHiddenCalendarIcon="true"
                :error="error(`income_recurrents[${index}].date`)"
                @input="changeDate"
              />
            </td>
            <td>
              <InputNumeric
                v-model="item.value"
                name="value"
                :error="error(`income_recurrents[${index}].value`)"
              />
            </td>
            <td class="actions">
              <a class="delete is-large" @click.prevent="removeRecurrence(index)"></a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </nav>
</template>

<script>
  import { api } from "../../../services.js";
  import inputable from "../../../mixins/inputable.js";

  export default {
    name: "New",
    mixins: [inputable],
    props: {
      items: Array,
      currentErrors: Object
    },
    computed: {
      activeItems() {
        return this.items.filter(item => !item._destroy);
      }
    },
    methods: {
      addRecurrence() {
        this.items.push({ id: null, date: null, value: null, _destroy: null });
      },
      removeRecurrence(index) {
        this.activeItems[index]._destroy = true;
      },
      changeDate(event) {
        this.$emit("change:date", event);
      }
    },
    watch: {
      currentErrors(newValue) {
        this.errors = newValue;
      }
    }
  }
</script>

<style scoped>
  .actions {
    width: 1%;
    text-align: center;
  }

  .panel {
    margin-bottom: 10px !important;
  }

  .panel-block {
    padding: 5px !important;
  }

  .date-th {
    min-width: 130px;
  }

  .actions b {
    margin-left: 5px;
    text-transform: capitalize;
  }
</style>
