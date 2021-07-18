import Vue from "vue"
import VueRouter from "vue-router";

Vue.use(VueRouter);

import home from "./views/home/index.vue";

import incomes from "./views/incomes/index.vue";
import newIncome from "./views/incomes/new.vue";
import editIncome from "./views/incomes/edit.vue";

import expenses from "./views/expenses/index.vue";
import newExpense from "./views/expenses/new.vue";
import editExpense from "./views/expenses/edit.vue";

import cards from "./views/cards/index.vue";
import newCard from "./views/cards/new.vue";
import editCard from "./views/cards/edit.vue";

import categories from "./views/categories/index.vue";
import newCategory from "./views/categories/new.vue";
import editCategory from "./views/categories/edit.vue";

import tags from "./views/tags/index.vue";
import newTag from "./views/tags/new.vue";
import editTag from "./views/tags/edit.vue";

const router = new VueRouter({
  linkActiveClass: "is-active",
  mode: "history",
  routes: [
    { path: "/", component: home },

    { path: "/incomes", component: incomes },
    { path: "/incomes/new", component: newIncome },
    { path: "/incomes/edit/:id", component: editIncome },

    { path: "/expenses", component: expenses },
    { path: "/expenses/new", component: newExpense },
    { path: "/expenses/edit/:id", component: editExpense },

    { path: "/cards", component: cards },
    { path: "/cards/new", component: newCard },
    { path: "/cards/edit/:id", component: editCard },

    { path: "/categories", component: categories },
    { path: "/categories/new", component: newCategory },
    { path: "/categories/edit/:id", component: editCategory },

    { path: "/tags", component: tags },
    { path: "/tags/new", component: newTag },
    { path: "/tags/edit/:id", component: editTag },
  ]
});

export default router;
