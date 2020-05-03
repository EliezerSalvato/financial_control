import { mapActions } from "vuex";
import InputText from "../components/inputs/InputText.vue";
import Select from "../components/inputs/Select.vue";
import CheckBox from "../components/inputs/CheckBox.vue";

export default {
  name: "Form",
  components: {
    InputText,
    Select,
    CheckBox
  },
  data() {
    return {
      errors: {}
    }
  },
  methods: {
    ...mapActions(["setCurrentMessage"]),
    error(field) {
      return (this.errors[field] ? this.errors[field][0] : "");
    },
    catch_errors(error) {
      const status = error.response["status"];

      if (status == 400) {
        this.setCurrentMessage(`ActionController::ParameterMissing: ${error.response.data.error}`);
      } else if (status == 404) {
        this.setCurrentMessage("Error editing, record not found!");
      } else if (status == 422) {
        if (error.response.data.error) {
          this.setCurrentMessage("Please check the required fields and try again.");
        } else {
          this.setCurrentMessage("Error editing, record invalid!");
        }
      }
    }
  },
  mounted() {
    if (this.$refs.input) {
      this.$refs.input.focus();
    }
  }
}
