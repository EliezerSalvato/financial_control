<template>
  <div>
    <label v-if="label" class="label" :for="name" @click="focus">
      {{ label }}
      <abbr v-if="label && required" title="required">*</abbr>
    </label>

    <div class="is-fullwidth">
      <Multiselect
        v-model="currentValue"
        ref="input"
        class="input-multiselect"
        label="name"
        :track-by="trackBy"
        :options="options"
        :multiple="true"
        :placeholder="placeholder"
        :hideSelected="true"
        :maxHeight="200"
        @select="select"
        @remove="remove"
      >
        <span slot="noResult">No results found.</span>
      </Multiselect>
    </div>
    <p class="help is-danger">{{ error }}</p>
  </div>
</template>

<script>
import Multiselect from 'vue-multiselect';

export default {
  name: "SelectMultiple",

  components: {
    Multiselect
  },

  props: {
    name: String,
    value: Array,
    label: String,
    error: String,
    placeholder: String,
    items: Array,
    trackBy: {
      type: String,
      default: 'id'
    },
    required: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: String,
      default: null
    }
  },

  data() {
      return {
        currentValue: null,
        selectedItems: [],
        persistedItems: []
      }
    },

  computed: {
    options() {
      return this.items || [];
    }
  },

  methods: {
    focus() {
      this.$refs.input.$el.focus();
    },
    select(selectedItem) {
      if (this.persistedItems.find(item => item.id == selectedItem.id)) {
        this.selectedItems.find(item => item.id == selectedItem.id)['_destroy'] = false;
      } else {
        delete selectedItem.id;
        this.selectedItems.push(selectedItem)
      }
    },
    remove(removedItem) {
      if (this.persistedItems.find(item => item.id == removedItem.id)) {
        this.selectedItems.find(item => item.id == removedItem.id)['_destroy'] = true;
      } else {
        this.selectedItems = this.selectedItems.filter(item => item.id != removedItem.id);
      }
    }
  },

  watch: {
    selectedItems() {
      this.$emit("input", this.selectedItems);
      this.$emit("change:selected", { name: this.name, value: this.selectedItems });
    },

    value() {
      if (this.value != this.selectedItems) {
        this.selectedItems = this.value;
      }
    },
  },

  updated() {
    if (this.value != null && this.selectedItems.length == 0) {
      this.currentValue = [ ...this.value ];
      this.selectedItems = [ ...this.value ];
      this.persistedItems = [ ...this.value ];
    }
  },
}
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style>
  .multiselect__tags {
    box-shadow: inset 0 1px 2px rgba(10, 10, 10, 0.1);
  }
</style>
