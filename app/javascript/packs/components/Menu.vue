<template>
  <nav class="navbar is-primary">
    <div class="container">
      <div class="navbar-brand">
        <a href="/" class="navbar-item has-text-weight-bold">
          <img src="../assets/money.png">
          Financial Control
        </a>

        <span class="navbar-burger burger" data-target="navMenu" @click="menuClick">
          <span></span>
          <span></span>
          <span></span>
        </span>
      </div>

      <div id="navMenu" class="navbar-menu">
        <div class="navbar-end" @click="menuClick">
          <router-link class="navbar-item" to="/" exact>
            Dashboard
          </router-link>
          <router-link class="navbar-item" to="/incomes">
            Incomes
          </router-link>
          <router-link class="navbar-item" to="/expenses">
            Expenses
          </router-link>
          <router-link class="navbar-item" to="/cards">
            Cards
          </router-link>
          <router-link class="navbar-item" to="/groups">
            Groups
          </router-link>
          <router-link class="navbar-item" to="/categories">
            Categories
          </router-link>
          <router-link class="navbar-item" to="/partners">
            Partners
          </router-link>
          <a href="/users/sign_out" class="navbar-item">
            <span class="icon is-hidden-touch">
              <i class="fas fa-sign-out-alt"></i>
            </span>
            <span class="is-hidden-desktop">
              Sair
            </span>
          </a>
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
  export default {
    name: "Menu",
    methods: {
      menuClick(event) {
        document.querySelector('.burger').classList.toggle("is-active");
        document.querySelector("#navMenu").classList.toggle("is-active");
      }
    }
  }
</script>

<style scoped>
  a img {
    margin-right: 5px;
  }
</style>
