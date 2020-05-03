import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  strict: true,
  state: {
    currentMessage: null,
    openModalDelete: false
  },
  mutations: {
    UPDATE_CURRENT_MESSAGE(state, message) {
      state.currentMessage = message;
    },
    UPDATE_OPEN_DELETE_MODAL(state, open) {
      state.openModalDelete = open;
    }
  },
  actions: {
    setCurrentMessage(context, message) {
      context.commit("UPDATE_CURRENT_MESSAGE", message);
    },
    setOpenModalDelete(context, open) {
      context.commit("UPDATE_OPEN_DELETE_MODAL", open);
    }
  }
});
