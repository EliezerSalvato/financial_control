<template>
  <FormPanel
    type="new"
    modelName="category"
    :hiddenBack="modal"
    @call:save="save"
  >
    <template #form>
      <div class="field">
        <div class="control">
          <InputText
            ref="name"
            v-model="name"
            name="name"
            label="Name"
            :required="true"
            :error="error('name')"
          />
        </div>
      </div>

      <div class="field">
        <div class="control">
          <InputNumeric
            v-model="goal"
            name="goal"
            label="Goal"
            :error="error('goal')"
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
        name: null,
        goal: null
      }
    },
    methods: {
      save() {
        const params = {
          name: this.name,
          goal: this.goal
        }

        api.post("categories", params).then(response => {
          if (response["status"] === 201) {
            if (this.modal) {
              this.$emit("new:category", response.data.id)
            } else {
              const message = "Category was successfully created.";
              this.setCurrentMessage({ message: message, type: "success" });
              this.$router.push({ path: "/categories", query: { keepMessage: true } });
            }
          }
        }).catch(error => {
          this.catch_errors(error);

          if (error.response["status"] === 422) {
            this.errors = error.response.data.error;
          }
        });
      }
    },
    mounted() {
      this.$refs.name.focus();
    }
  }
</script>

<style scoped>
</style>
