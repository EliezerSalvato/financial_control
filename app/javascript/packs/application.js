import Vue from "vue"
import App from "./app.vue"
import router from "./routes.js";
import store from "./store.js";
import Loading from "./components/Loading";

Vue.config.productionTip = false

Vue.component("Loading", Loading)

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
