import Vue from "vue"
import VueRouter from "vue-router";

Vue.use(VueRouter);

import dashboard from "./views/dashboard/index.vue";
import incomes from "./views/incomes/index.vue";

import expenses from "./views/expenses/index.vue";
import newExpense from "./views/expenses/new.vue";
import editExpense from "./views/expenses/edit.vue";

import cards from "./views/cards/index.vue";
import newCard from "./views/cards/new.vue";
import editCard from "./views/cards/edit.vue";

import groups from "./views/groups/index.vue";
import newGroup from "./views/groups/new.vue";
import editGroup from "./views/groups/edit.vue";

import categories from "./views/categories/index.vue";
import newCategory from "./views/categories/new.vue";
import editCategory from "./views/categories/edit.vue";

import partners from "./views/partners/index.vue";

const router = new VueRouter({
  linkActiveClass: "is-active",
  mode: "history",
  routes: [
    { path: "/", component: dashboard },
    { path: "/incomes", component: incomes },

    { path: "/expenses", component: expenses },
    { path: "/expenses/new", component: newExpense },
    { path: "/expenses/edit/:id", component: editExpense },

    { path: "/cards", component: cards },
    { path: "/cards/new", component: newCard },
    { path: "/cards/edit/:id", component: editCard },

    { path: "/groups", component: groups },
    { path: "/groups/new", component: newGroup },
    { path: "/groups/edit/:id", component: editGroup },

    { path: "/categories", component: categories },
    { path: "/categories/new", component: newCategory },
    { path: "/categories/edit/:id", component: editCategory },

    { path: "/partners", component: partners }
  ]
});

export default router;
