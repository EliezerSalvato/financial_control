import Vue from "vue"
import App from "./app.vue"
import router from "./routes.js";
import store from "./store.js";

Vue.config.productionTip = false

router.beforeEach((to, _from, next) => {
  if (!to.query["keepMessage"]) {
    store.dispatch("setCurrentMessage", "");
  }

  next();
});

window.onload = () => {
  if (document.getElementById("app") != null) {
    new Vue({
      router,
      store,
      render: h => h(App),
    }).$mount("#app");
  }
}
