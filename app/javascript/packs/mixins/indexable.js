import inputable from "./inputable.js";

export default {
  name: "Indexable",
  mixins: [inputable],
  data() {
    return {
      items: null,
      paginatable: {},
      currentQuery: { filter: {} }
    }
  },
  methods: {
    getData() {},
    changePage(page) {
      this.currentQuery["page"] = page
      this.getData();
    },
    filterChange(event) {
      this.currentQuery["filter"][event.name] = event.value;
      this.changePage(1);
    },
    catch_errors(error) {
      const status = error.response["status"];

      if (status == 400) {
        const message = `ActionController::ParameterMissing: ${error.response.data.error}`;
        this.setCurrentMessage(message);
      } else if (status == 422) {
        const message = `Error removing: ${error.response.data.error.base[0]}`;
        this.setCurrentMessage(message);
      }
    }
  },
  created() {
    this.getData();
  }
}
