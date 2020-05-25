<template>
  <FormPanel
    type="new"
    modelName="card"
    @call:save="save"
  >
    <template #form>
      <div class="field">
        <div class="control">
          <InputText
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
          <Select
            v-model="cardType"
            name="card_type"
            label="Card type"
            placeholder="Choose a card type"
            :required="true"
            :items="CARD_TYPES"
            :error="error('card_type')"
          />
        </div>
      </div>

      <creditsForm v-if="cardType == CARD_TYPES.Credit" v-model="credit" :form_errors="errors" />
    </template>
  </FormPanel>
</template>

<script>
  import { api } from "../../services.js";
  import creditsForm from "./credits/form.vue";
  import formable from "../../mixins/formable.js";
  import enumerable from "../../mixins/enumerable.js";
  import FormPanel from "../../components/FormPanel.vue";

  export default {
    name: "New",
    mixins: [formable, enumerable],
    components: {
      creditsForm,
      FormPanel
    },
    data() {
      return {
        name: null,
        cardType: null,
        credit: {
          limit: null,
          super_limit: null,
          due_day: null,
          closing_day: null
        }
      }
    },
    methods: {
      cardAttributes(type) {
        switch(type) {
          case this.CARD_TYPES.Credit: return this.credit; break;
          default: return null;
        }
      },
      save() {
        const params = {
          name: this.name,
          card_type: this.cardType,
          card_attributes: this.cardAttributes(this.cardType)
        }

        api.post("cards", params).then(response => {
          if (response["status"] === 201) {
            const message = "Card was successfully created.";
            this.setCurrentMessage({ message: message, type: "success" });
            this.$router.push({ path: "/cards", query: { keepMessage: true } });
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