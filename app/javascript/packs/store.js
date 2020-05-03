import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  strict: true,
  state: {
    currentMessage: null,
    currentMessageType: null,
    openModalDelete: false
  },
  mutations: {
    UPDATE_CURRENT_MESSAGE(state, message) {
      state.currentMessage = message;
    },
    UPDATE_CURRENT_MESSAGE_TYPE(state, type) {
      state.currentMessageType = type;
    },
    UPDATE_OPEN_DELETE_MODAL(state, open) {
      state.openModalDelete = open;
    }
  },
  actions: {
    setCurrentMessage(context, payload) {
      var type = "danger";
      var message = payload;

      if (typeof payload != "string") {
        type = payload.type;
        message = payload.message;
      }

      context.commit("UPDATE_CURRENT_MESSAGE", message);
      context.commit("UPDATE_CURRENT_MESSAGE_TYPE", type);
    },
    setOpenModalDelete(context, open) {
      context.commit("UPDATE_OPEN_DELETE_MODAL", open);
    }
  }
});
