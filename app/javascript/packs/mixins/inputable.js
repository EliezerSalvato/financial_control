import InputText from "../components/inputs/InputText.vue";
import Select from "../components/inputs/Select.vue";
import CheckBox from "../components/inputs/CheckBox.vue";

export default {
  name: "Inputable",
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
    error(field) {
      return (this.errors[field] ? this.errors[field][0] : "");
    },
  }
}
