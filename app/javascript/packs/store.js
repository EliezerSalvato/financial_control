import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  strict: true,
  state: {
    currentMessage: null
  },
  mutations: {
    UPDATE_CURRENT_MESSAGE(state, message) {
      state.currentMessage = message;
    }
  },
  actions: {
    setCurrentMessage(context, message) {
      context.commit("UPDATE_CURRENT_MESSAGE", message);
    }
  }
});
