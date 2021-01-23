<template>
  <FormPanel
    type="new"
    modelName="tag"
    :hiddenBack="modal"
    @call:save="save"
  >
    <template #form>
      <div class="field">
        <div class="control">
          <InputText
            v-model="name"
            name="name"
            label="Name"
            ref="input"
            :required="true"
            :error="error('name')"
          />
        </div>
      </div>
    </template>
  </FormPanel>
</template>

<script>
  import { api } from "../../services.js";
  import formable from "../../mixins/formable.js";
  import FormPanel from "../../components/FormPanel.vue";

  export default {
    name: "New",
    mixins: [formable],
    components: {
      FormPanel
    },
    props: {
      modal: { type: Boolean, default: false }
    },
    data() {
      return {
        name: null
      }
    },
    methods: {
      save() {
        const params = {
          name: this.name
        }

        api.post("tags", params).then(response => {
          if (response["status"] === 201) {
            if (this.modal) {
              this.$emit("new:tag", response.data.id)
            } else {
              const message = "Tag was successfully created.";
              this.setCurrentMessage({ message: message, type: "success" });
              this.$router.push({ path: "/tags", query: { keepMessage: true } });
            }
          }
        }).catch(error => {
          this.catch_errors(error);

          if (error.response["status"] === 422) {
            this.errors = error.response.data.error;
          }
        });
      }
    }
  }
</script>

<style scoped>
</style>
