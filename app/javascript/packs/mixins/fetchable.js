import { mapActions } from "vuex";
import { api } from "../services.js";

export default {
  methods: {
    ...mapActions(["setShowLoading"]),
    setLoading(params, active) {

      if (params.loading || Object.entries(params).length == 0 || Object.entries(params.filter).length == 0) {
        this.setShowLoading(active);
      }
    },
    async getWithLoading(url, params = {}) {
      this.setLoading(params, true);
      const result = await api.get(url, params);
      this.setLoading(params, false);

      return result;
    }
  }
};
