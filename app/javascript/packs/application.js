import Vue from 'vue'
import App from './app.vue'
import router from './routes.js';

Vue.config.productionTip = false

window.onload = () => {
  if (document.getElementById("app") != null) {
    new Vue({
      router,
      render: h => h(App),
    }).$mount('#app');
  }
}
