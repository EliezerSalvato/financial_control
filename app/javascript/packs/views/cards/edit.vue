<template>
  <FormPanel
    type="edit"
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
            :items="CardTypes.values"
            :error="error('card_type')"
            disabled
          />
        </div>
      </div>

      <creditsForm v-if="cardType == CardTypes.CREDIT" v-model="credit" :form_errors="errors" />

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
  import creditsForm from "./credits/form.vue";
  import formable from "../../mixins/formable.js";
  import enumerable from "../../mixins/enumerable.js";
  import FormPanel from "../../components/FormPanel.vue";

  export default {
    name: "Edit",
    mixins: [formable, enumerable],
    components: {
      creditsForm,
      FormPanel
    },
    data() {
      return {
        name: null,
        cardId: null,
        cardType: null,
        credit: {
          limit: null,
          super_limit: null,
          due_day: null,
          closing_day: null
        },
        active: null
      }
    },
    methods: {
      cardAttributes(type) {
        switch(type) {
          case this.CardTypes.CREDIT: return this.credit; break;
          default: return null;
        }
      },
      save() {
        const params = {
          name: this.name,
          card_id: this.cardId,
          card_type: this.cardType,
          active: this.active,
          card_attributes: Object.assign(this.cardAttributes(this.cardType), { id: this.cardId })
        }

        api.put(`cards/${this.$route.params.id}`, params).then(response => {
          if (response["status"] === 200) {
            const message = "Card was successfully updated.";
            this.setCurrentMessage({ message: message, type: "success" });
            this.$router.push({ path: "/cards", query: { keepMessage: true } });
          }
        }).catch(error => {
          this.catch_errors(error);

          if (error.response["status"] === 422) {
            this.errors = error.response.data.error;
          }
        });
      },
      setCardByType(result) {
        switch(result.card_type) {
          case this.CardTypes.CREDIT:
            const super_limit = result.card.super_limit;
            this.credit = {
              limit: Number(result.card.limit),
              super_limit: (super_limit != null ? Number(super_limit) : null),
              due_day: result.card.due_day,
              closing_day: result.card.closing_day,
            }
            break;
        }
      }
    },
    created() {
      if (this.$route.params.id) {
        this.getWithLoading(`cards/${this.$route.params.id}`).then(response => {
          const result = response.data;
          this.name = result.name;
          this.active = result.active;
          this.cardId = result.card_id;
          this.cardType = result.card_type;

          this.setCardByType(result);
        }).catch(error => {
          this.catch_errors(error);
        });
      }
    }
  }
</script>

<style scoped>
</style>
