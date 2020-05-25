<template>
  <div ref="wrapper">
    <label v-if="label" class="label" :for="name">
      {{ label }}
      <abbr v-if="label && required" title="required">*</abbr>
    </label>
    <input
      type="date"
      ref="calendar"
      class="calendar is-hidden"
      :class="{ 'is-danger': error }"
    />
    <p class="help is-danger">{{ error }}</p>
  </div>
</template>

<script>
  import moment from "moment";
  import bulmaCalendar from 'bulma-calendar/dist/js/bulma-calendar.min.js';

  export default {
    name: "Calendar",
    props: {
      name: String,
      value: String,
      label: String,
      error: String,
      required: { type: Boolean, default: false },
      withDefaultDate: { type: Boolean, default: false },
      canHiddenCalendarIcon: { type: Boolean, default: false }
    },
    data() {
      return {
        calendar: null,
        backDateFormat: "YYYY-MM-DD",
        frontDateFormat: "DD/MM/YYYY"
      }
    },
    methods: {
      changeDate(value) {
        if (value != null) {
          value = moment(value, this.frontDateFormat).format(this.backDateFormat);
        }

        this.$emit("input", value);
      },
      refreshDate() {
        this.calendar.value(new Date(moment(this.value, this.backDateFormat).format()));
      }
    },
    watch: {
      error(value) {
        const wrapper = this.$refs.wrapper.querySelector(".datetimepicker-dummy-wrapper");

        if (!!value) {
          wrapper.parentElement.classList.add("is-danger");
          wrapper.classList.add("is-danger");
        } else {
          wrapper.parentElement.classList.remove("is-danger");
          wrapper.classList.remove("is-danger");
        }
      },
      value(newValue) {
        if (!newValue) {
          this.$refs.wrapper.querySelector(".datetimepicker-dummy-input").value = "";
          return;
        }

        const currentDate = moment(this.calendar.value(), this.frontDateFormat).format(this.backDateFormat);

        if (currentDate != newValue) {
          this.refreshDate();
        }
      }
    },
    mounted() {
      const startDate = (this.value || (this.withDefaultDate ? moment().format(this.backDateFormat) : null));
      this.calendar = bulmaCalendar.attach(this.$refs.calendar, {
        displayMode: "dialog",
        lang: "en",
        showHeader: false,
        showClearButton: false,
        dateFormat: this.frontDateFormat,
        startDate: new Date(moment(startDate, this.backDateFormat).format())
      })[0];

      if (!!startDate) {
        this.changeDate(moment(startDate, this.backDateFormat).format(this.frontDateFormat));
      }

      this.calendar.on("select", event => {
        this.changeDate(event.data.value());
      });

      this.$refs.wrapper.querySelector(".datetimepicker-clear-button").addEventListener("click", event => {
        event.preventDefault();
        this.changeDate(null);
      });

      if (this.canHiddenCalendarIcon) {
        this.$refs.wrapper.querySelector(".datetimepicker-dummy").classList.add("can-hidden-calendar-icon");
        this.$refs.wrapper.querySelector(".datetimepicker-dummy-input").classList.add("can-hidden-calendar-icon");
        this.$refs.wrapper.querySelector(".datetimepicker-clear-button").classList.add("can-hidden-calendar-icon");
      }
    }
  }
</script>

<style scopped>
  @import "bulma-calendar/dist/css/bulma-calendar.min.css";

  .datetimepicker-dummy-input {
    max-width: 155px !important;
  }

  .datetimepicker-dummy-wrapper {
    border-radius: 4px;
    border-color: #dbdbdb !important;
    box-shadow: inset 0 1px 2px rgba(10, 10, 10, 0.1);
    height: 35px !important;
  }

  .datetimepicker-dummy-wrapper.is-danger {
    border-color: #ff3860 !important;
  }

  .datetimepicker-dummy-wrapper:hover {
    border-color: #b5b5b5 !important;
  }

  .datetimepicker-dummy::before {
    margin-top: -2px !important;
  }

  .datetimepicker-clear-button {
    margin-top: 1px !important;
  }

  @media screen and (max-width: 414px) {
    .can-hidden-calendar-icon::before {
      content: none;
    }

    .datetimepicker-dummy-input.can-hidden-calendar-icon {
      max-width: 145px !important;
      margin-left: -35px !important;
    }

    .datetimepicker-clear-button.can-hidden-calendar-icon {
      margin-right: -5px !important;
    }
  }
</style>
