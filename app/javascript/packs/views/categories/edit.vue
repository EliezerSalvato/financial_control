<template>
  <FormPanel
    type="edit"
    modelName="category"
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

      <div class="field">
        <div class="control">
          <CheckBox v-model="active" name="active" label="Active" />
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
    name: "Edit",
    mixins: [formable],
    components: {
      FormPanel
    },
    data() {
      return {
        name: null,
        goal: null,
        active: null
      }
    },
    methods: {
      save() {
        const params = {
          name: this.name,
          goal: this.goal,
          active: this.active
        }

        api.put(`categories/${this.$route.params.id}`, params).then(response => {
          if (response["status"] === 200) {
            const message = "Category was successfully updated.";
            this.setCurrentMessage({ message: message, type: "success" });
            this.$router.push({ path: "/categories", query: { keepMessage: true } });
          }
        }).catch(error => {
          this.catch_errors(error);

          if (error.response["status"] === 422) {
            this.errors = error.response.data.error;
          }
        });
      }
    },
    created() {
      if (this.$route.params.id) {
        this.getWithLoading(`categories/${this.$route.params.id}`).then(response => {
          const result = response.data;
          this.name = result.name;
          this.goal = result.goal;
          this.active = result.active;
          this.$refs.name.focus();
        }).catch(error => {
          this.catch_errors(error);
        });
      }
    }
  }
</script>

<style scoped>
</style>
