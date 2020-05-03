<template>
  <div>
    <div v-if="total_count" class="is-pulled-left is-hidden-touch">
      Displaying <b>{{ fromRecord }} - {{ toRecord }}</b> of <b>{{ total_count }}</b> in total
    </div>
    <div v-else class="is-pulled-left">
      No records found.
    </div>
    <div class="is-pulled-right">
      <nav class="pagination">
        <div class="is-hidden-desktop">
          <a v-if="prev_page != null" rel="prev" class="pagination-link" @click="changePage(prev_page)">‹ Prev</a>
          <a v-if="next_page != null" rel="next" class="pagination-link" @click="changePage(next_page)">Next ›</a>
        </div>

        <ul class="pagination-list">
          <li v-if="prev_page != null">
            <a class="pagination-link" @click="changePage(1)">« First</a>
          </li>

          <li v-if="prev_page != null" class="is-hidden-touch">
            <a rel="prev" class="pagination-link" @click="changePage(prev_page)">‹ Prev</a>
          </li>

          <li v-for="page in pagesList" :key="page">
            <a
              v-if="pagesList.length > 1"
              rel="prev"
              class="pagination-link"
              :class="{
                'is-current': (current_page == page),
                'is-hidden-touch': (![prev_page, current_page, next_page].includes(page))
              }"
              @click="changePage(page)">
              {{ page }}
            </a>
          </li>

          <li v-if="next_page != null" class="is-hidden-touch">
            <a rel="next" class="pagination-link" @click="changePage(next_page)">Next ›</a>
          </li>

          <li v-if="next_page != null">
            <a class="pagination-link" @click="changePage(total_pages)">Last »</a>
          </li>
        </ul>
      </nav>
    </div>
  </div>
</template>

<script>
  export default {
    name: "Paginator",
    props: {
      paginatable: {
        type: Object,
        required: true
      }
    },
    computed: {
      current_page() {
        return this.paginatable.current_page;
      },
      prev_page() {
        return this.paginatable.prev_page;
      },
      next_page() {
        return this.paginatable.next_page;
      },
      total_pages() {
        return this.paginatable.total_pages;
      },
      total_count() {
        return this.paginatable.total_count;
      },
      fromRecord() {
        return this.paginatable.offset_value + 1;
      },
      toRecord() {
        return this.paginatable.offset_value + this.paginatable.size;
      },
      pagesList() {
        const limit_pages = 2;
        const displayable_pages = [];
        const first_page = this.current_page - limit_pages;
        const last_page = this.current_page + limit_pages;

        for (let i = first_page; i <= last_page; i++) {
          if (i >= 1 && i <= this.total_pages) {
            displayable_pages.push(i);
          }
        }

        return displayable_pages;
      }
    },
    methods: {
      changePage(page) {
        this.$emit("change:page", page);
      }
    }
  }
</script>

<style scoped>
  .pagination-link {
    margin: 3px;
  }
</style>
