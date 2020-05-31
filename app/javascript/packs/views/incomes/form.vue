<template>
  <div class="income">
    <div class="field">
      <div class="control">
        <InputText
          v-model="description"
          name="description"
          label="Description"
          :required="true"
          :error="error('description')"
        />
      </div>
    </div>
    <div class="field">
      <div class="control">
        <Select
          v-model="incomeType"
          name="income_type"
          label="Income Type"
          placeholder="Choose a income type"
          :required="true"
          :disabled="(type == 'edit' ? 'disabled' : null)"
          :items="IncomeTypes.values"
          :error="error('income_type')"
        />
      </div>
    </div>
    <div v-if="showCard" class="field">
      <div class="control with-add">
        <Select
          v-model="cardId"
          name="card"
          label="Card"
          placeholder="Choose a card"
          :required="true"
          :items="cards"
          :error="error('card')"
        />
        <a class="button is-primary" @click.prevent="openModalCard">
          <i class="fa fa-plus"></i>
        </a>
      </div>
    </div>
    <div class="field">
      <div class="control with-add">
        <Select
          v-model="categoryId"
          name="category"
          label="Category"
          placeholder="Choose a category"
          :required="true"
          :items="categories"
          :error="error('category')"
        />
        <a class="button is-primary" @click.prevent="openModalCategory">
          <i class="fa fa-plus"></i>
        </a>
      </div>
    </div>
    <div class="field">
      <div class="control with-add">
        <Select
          v-model="groupId"
          name="group"
          label="Group"
          placeholder="Choose a group"
          :items="groups"
          :error="error('group')"
        />
        <a class="button is-primary" @click.prevent="openModalGroup">
          <i class="fa fa-plus"></i>
        </a>
      </div>
    </div>
    <div v-if="showQuantity" class="field">
      <div class="control">
        <InputNumber
          v-model="quantity"
          name="quantity"
          label="Quantity"
          :minValue="1"
          :maxValue="999"
          :required="quantityRequired"
          :error="error('quantity')"
        />
      </div>
    </div>
    <div v-if="showValue" class="field">
      <div class="control">
        <InputNumeric
          v-model="value"
          name="value"
          label="Value"
          :required="true"
          :error="error('value')"
        />
      </div>
    </div>
    <div v-if="showDate" class="field">
      <div class="control">
        <Calendar
          v-model="date"
          name="date"
          label="Date"
          :required="true"
          :withDefaultDate="true"
          :error="error('date')"
        />
      </div>
    </div>
    <div v-if="showEndAt" class="field">
      <div class="control">
        <Calendar
          v-model="endAt"
          name="end_at"
          label="End At"
          :error="error('end_at')"
        />
      </div>
    </div>

    <IncomeRecurrents
      v-if="showRecurrence"
      :items="incomeRecurrents"
      :currentErrors="errors"
      @change:date="changeDate"
    />

    <Modal :openModal="openModal">
      <template #body>
        <newCard v-if="modalType == 'card'" :modal="true" @new:card="newCard" />
        <newGroup v-if="modalType == 'group'" :modal="true" @new:group="newGroup" />
        <newCategory v-if="modalType == 'category'" :modal="true" @new:category="newCategory" />
      </template>
      <template #footer>
        <button class="button" @click.prevent="closeModal">Close</button>
      </template>
    </Modal>
  </div>
</template>

<script>
  import moment from "moment";
  import { api } from "../../services.js";
  import formable from "../../mixins/formable.js";
  import enumerable from "../../mixins/enumerable.js";
  import Modal from "../../components/Modal.vue";
  import newCard from "../cards/new.vue";
  import newGroup from "../groups/new.vue";
  import newCategory from "../categories/new.vue";
  import FormPanel from "../../components/FormPanel.vue";
  import IncomeRecurrents from "./income_recurrents/form.vue";

  export default {
    name: "Form",
    mixins: [formable, enumerable],
    components: {
      FormPanel,
      newCard,
      newGroup,
      newCategory,
      Modal,
      IncomeRecurrents
    },
    props: {
      type: {
        type: String,
        required: true
      },
      currentErrors: Object,
      incomeLoaded: Object
    },
    data() {
      return {
        description: null,
        incomeType: null,
        cardId: null,
        categoryId: null,
        groupId: null,
        quantity: null,
        value: null,
        date: null,
        endAt: null,
        incomeRecurrents: [],
        cards: null,
        categories: null,
        groups: null,
        endAtWatcher: null,
        modalType: null,
        openModal: false
      }
    },
    computed: {
      defaultQuery() {
        return {
          filter: {
            by_active: true
          }
        }
      },
      showCard() {
        return ([this.IncomeTypes.CARD, this.IncomeTypes.SALARY].includes(this.incomeType));
      },
      showQuantity() {
        return (this.IncomeTypes.SALARY == this.incomeType);
      },
      showValue() {
        return ([this.IncomeTypes.CARD, this.IncomeTypes.CASH].includes(this.incomeType));
      },
      showDate() {
        return ([this.IncomeTypes.CARD, this.IncomeTypes.CASH].includes(this.incomeType));
      },
      showEndAt() {
        return (this.IncomeTypes.SALARY == this.incomeType);
      },
      showRecurrence() {
        return (this.IncomeTypes.SALARY == this.incomeType);
      },
      quantityRequired() {
        return (this.IncomeTypes.CASH == this.incomeType);
      }
    },
    methods: {
      closeModal() {
        this.modalType = null;
        this.openModal = false;
      },
      getCards() {
        api.get("cards", this.defaultQuery).then(response => {
          const result = response.data;
          this.cards = result.data;
        });
      },
      newCard(cardId) {
        this.getCards();
        this.cardId = cardId;
        this.closeModal();
      },
      openModalCard() {
        this.modalType = "card";
        this.openModal = true;
      },
      getCategories() {
        api.get("categories", this.defaultQuery).then(response => {
          const result = response.data;
          this.categories = result.data;
        });
      },
      newCategory(categoryId) {
        this.getCategories();
        this.categoryId = categoryId;
        this.closeModal();
      },
      openModalCategory() {
        this.modalType = "category";
        this.openModal = true;
      },
      getGroups() {
        api.get("groups", this.defaultQuery).then(response => {
          const result = response.data;
          this.groups = result.data;
        });
      },
      newGroup(groupId) {
        this.getGroups();
        this.groupId = groupId;
        this.closeModal();
      },
      openModalGroup() {
        this.modalType = "group";
        this.openModal = true;
      },
      addRecurrence() {
        this.incomeRecurrents.push({ id: null, date: null, value: null });
      },
      getQuantity(startDate) {
        if (this.endAt == null) { return null; }

        const endDate = moment(this.endAt, this.DateFormat.BACK_END);

        return (endDate.diff(startDate, "months") + 1);
      },
      setEndAt(quantity, date) {
        this.removeEndAtWatcher();

        if (quantity == null || date == null) {
          this.endAt = null;
        } else {
          let currentDate = moment(date, this.DateFormat.BACK_END).add(quantity - 1, "M");
          this.endAt = currentDate.set("D", currentDate.get("D")).format(this.DateFormat.BACK_END);
        }

        this.addEndAtWatcher();
      },
      firstDate(incomeRecurrents = this.incomeRecurrents) {
        const dates = incomeRecurrents.map(
          incomeRecurrent => moment(incomeRecurrent.date, this.DateFormat.BACK_END)
        );

        return moment.min(dates).format(this.DateFormat.BACK_END);
      },
      firstIncomeRecurrent(incomeRecurrents = this.incomeRecurrents) {
        const firstDate = this.firstDate(incomeRecurrents);

        return incomeRecurrents.find(
          incomeRecurrent => incomeRecurrent.date == firstDate
        )
      },
      changeDate(event) {
        this.date = this.firstDate();
      },
      addEndAtWatcher() {
        this.endAtWatcher = this.$watch("endAt", () => {
          this.quantity = this.getQuantity(this.date);
        });
      },
      removeEndAtWatcher() {
        this.endAtWatcher();
      },
      emitChangeIncome() {
        const income = {
          description: this.description,
          incomeType: this.incomeType,
          cardId: this.cardId,
          categoryId: this.categoryId,
          groupId: this.groupId,
          quantity: this.quantity,
          value: this.value,
          date: this.date,
          endAt: this.endAt,
          incomeRecurrents: this.incomeRecurrents
        }

        this.$emit("change:income", income);
      },
      setWatchers() {
        const keys = [
          "description",
          "incomeType",
          "cardId",
          "categoryId",
          "groupId",
          "quantity",
          "value",
          "date",
          "endAt",
          "incomeRecurrents"
        ];

        keys.forEach(key => {
          this.$watch(key, () => {
            this.emitChangeIncome();
          });
        });

        this.addEndAtWatcher();
      },
      async fetchSelects() {
        await this.getCards();
        await this.getCategories();
        await this.getGroups();
      }
    },
    watch: {
      incomeType(newValue) {
        if (this.type == "edit") { return; }

        if (newValue == "") {
          this.incomeType = null;
        }

        switch(this.incomeType) {
          case this.IncomeTypes.SALARY:
            if (!this.incomeRecurrents.length) {
              this.addRecurrence();
            }

            this.quantity = null;
            break;
          default:
            this.quantity = 1;
        }
      },
      quantity(newValue) {
        this.setEndAt(newValue, this.date);
      },
      date(newValue) {
        this.setEndAt(this.quantity, newValue);
      },
      currentErrors(newValue) {
        this.errors = newValue;
      },
      incomeLoaded(income) {
        this.fetchSelects();

        this.incomeRecurrents = income.incomeRecurrents;
        const firstIncomeRecurrent = this.firstIncomeRecurrent();
        this.value = firstIncomeRecurrent.value;
        this.date = firstIncomeRecurrent.date;
        this.endAt = income.endAt;
        this.quantity = this.getQuantity(this.date);
        this.description = income.description;
        this.incomeType = income.incomeType;
        this.cardId = income.cardId;
        this.categoryId = income.categoryId;
        this.groupId = income.groupId;

        this.setWatchers();
        this.emitChangeIncome();
      }
    },
    created() {
      if (this.type == "new") {
        this.fetchSelects();
        this.setWatchers();
      }
    }
  }
</script>

<style scoped>
  .income {
    margin-bottom: 15px;
  }

  .with-add {
    display: flex;
  }

  .with-add div {
    flex-grow: 1;
  }

  .with-add a {
    flex-grow: 0;
    margin-top: 32px;
    margin-left: 5px;
  }
</style>
