import Vue from 'vue'
import VueRouter from 'vue-router';

Vue.use(VueRouter);

import dashboard from './views/dashboard/index.vue';
import incomes from './views/incomes/index.vue';
import expenses from './views/expenses/index.vue';
import cards from './views/cards/index.vue';
import groups from './views/groups/index.vue';
import categories from './views/categories/index.vue';
import partners from './views/partners/index.vue';

const router = new VueRouter({
  linkExactActiveClass: 'is-active',
  mode: 'history',
  routes: [
    { path: '/', component: dashboard },
    { path: '/incomes', component: incomes },
    { path: '/expenses', component: expenses },
    { path: '/cards', component: cards },
    { path: '/groups', component: groups },
    { path: '/categories', component: categories },
    { path: '/partners', component: partners }
  ]
});

export default router;
