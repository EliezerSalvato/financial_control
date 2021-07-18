<template>
  <div class="expense">
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
          v-model="expenseType"
          name="expense_type"
          label="Expense Type"
          placeholder="Select an expense type"
          :required="true"
          :disabled="(type == 'edit' ? 'disabled' : null)"
          :items="ExpenseTypes.values"
          :error="error('expense_type')"
        />
      </div>
    </div>
    <div v-if="showCard" class="field">
      <div class="control with-add">
        <Select
          v-model="cardId"
          name="card"
          label="Card"
          placeholder="Select a card"
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
          placeholder="Select a category"
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
        <SelectMultiple
          v-model="expenseTags"
          name="tags"
          label="Tags"
          placeholder="Select tags"
          trackBy="tag_id"
          :items="tags"
          :error="error('tags')"
        />
        <a class="button is-primary add-select-multi" @click.prevent="openModalTag">
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

    <ExpenseRecurrents
      v-if="showRecurrence"
      :items="expenseRecurrents"
      :currentErrors="errors"
      @change:date="changeDate"
    />

    <Modal :openModal="openModal">
      <template #body>
        <newCard v-if="modalType == 'card'" :modal="true" @new:card="newCard" />
        <newTag v-if="modalType == 'tag'" :modal="true" @new:tag="newTag" />
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
  import newTag from "../tags/new.vue";
  import newCategory from "../categories/new.vue";
  import FormPanel from "../../components/FormPanel.vue";
  import ExpenseRecurrents from "./expense_recurrents/form.vue";

  export default {
    name: "Form",
    mixins: [formable, enumerable],
    components: {
      newCard,
      newTag,
      newCategory,
      Modal,
      FormPanel,
      ExpenseRecurrents
    },
    props: {
      type: {
        type: String,
        required: true
      },
      currentErrors: Object,
      expenseLoaded: Object
    },
    data() {
      return {
        description: null,
        expenseType: null,
        cardId: null,
        categoryId: null,
        expenseTags: null,
        quantity: null,
        value: null,
        date: null,
        endAt: null,
        expenseRecurrents: [],
        cards: null,
        categories: null,
        tags: null,
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
          },
          show_all: true
        }
      },
      installments() {
        return [this.ExpenseTypes.INSTALLMENT, this.ExpenseTypes.RECURRING_INSTALLMENTS];
      },
      showCard() {
        return (
          this.installments.concat(this.ExpenseTypes.CARD, this.ExpenseTypes.CARD_RECURRING_EXPENSE)
        ).includes(this.expenseType);
      },
      showQuantity() {
        return (
          this.installments.concat(
            this.ExpenseTypes.CARD_RECURRING_EXPENSE,
            this.ExpenseTypes.CASH_RECURRING_EXPENSE
          )
        ).includes(this.expenseType);
      },
      showValue() {
        return (
          this.installments.concat(this.ExpenseTypes.CARD, this.ExpenseTypes.CASH)
        ).includes(this.expenseType);
      },
      showDate() {
        return (
          this.installments.concat(this.ExpenseTypes.CARD, this.ExpenseTypes.CASH)
        ).includes(this.expenseType);
      },
      showEndAt() {
        return (
          [
            this.ExpenseTypes.CARD_RECURRING_EXPENSE,
            this.ExpenseTypes.CASH_RECURRING_EXPENSE
          ]
        ).includes(this.expenseType);
      },
      showRecurrence() {
        return (
          [
            this.ExpenseTypes.CARD_RECURRING_EXPENSE,
            this.ExpenseTypes.CASH_RECURRING_EXPENSE
          ]
        ).includes(this.expenseType);
      },
      quantityRequired() {
        return this.installments.includes(this.expenseType);
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
      getTags() {
        api.get("tags", this.defaultQuery).then(response => {
          const result = response.data;
          this.tags = result.data.map(tag => {
            return {
              id: tag.id,
              tag_id: tag.id,
              name: tag.name
            }
          });
        });
      },
      newTag(_tagId) {
        this.getTags();
        this.closeModal();
      },
      openModalTag() {
        this.modalType = "tag";
        this.openModal = true;
      },
      addRecurrence() {
        this.expenseRecurrents.push({ id: null, date: null, value: null });
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
      firstDate(expenseRecurrents = this.expenseRecurrents) {
        const dates = expenseRecurrents.map(
          expenseRecurrent => moment(expenseRecurrent.date, this.DateFormat.BACK_END)
        );

        return moment.min(dates).format(this.DateFormat.BACK_END);
      },
      firstExpenseRecurrent(expenseRecurrents = this.expenseRecurrents) {
        const firstDate = this.firstDate(expenseRecurrents);

        return expenseRecurrents.find(
          expenseRecurrent => expenseRecurrent.date == firstDate
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
      emitChangeExpense() {
        const expense = {
          description: this.description,
          expenseType: this.expenseType,
          cardId: this.cardId,
          categoryId: this.categoryId,
          quantity: this.quantity,
          value: this.value,
          date: this.date,
          endAt: this.endAt,
          expenseTags: this.expenseTags,
          expenseRecurrents: this.expenseRecurrents
        }

        this.$emit("change:expense", expense);
      },
      setWatchers() {
        const keys = [
          "description",
          "expenseType",
          "cardId",
          "categoryId",
          "quantity",
          "value",
          "date",
          "endAt",
          "expenseTags",
          "expenseRecurrents"
        ];

        keys.forEach(key => {
          this.$watch(key, () => {
            this.emitChangeExpense();
          });
        });

        this.addEndAtWatcher();
      },
      async fetchSelects() {
        await this.getCards();
        await this.getCategories();
        await this.getTags();
      }
    },
    watch: {
      expenseType(newValue) {
        if (this.type == "edit") { return; }

        if (newValue == "") {
          this.expenseType = null;
        }

        switch(this.expenseType) {
          case this.ExpenseTypes.CARD_RECURRING_EXPENSE:
          case this.ExpenseTypes.CASH_RECURRING_EXPENSE:
            if (!this.expenseRecurrents.length) {
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
      expenseLoaded(expense) {
        this.fetchSelects();

        this.expenseType = expense.expenseType;
        this.cardId = expense.cardId;
        this.categoryId = expense.categoryId;

        if (this.type == "edit") {
          this.expenseRecurrents = expense.expenseRecurrents;
          const firstExpenseRecurrent = this.firstExpenseRecurrent();
          this.value = firstExpenseRecurrent.value;
          this.date = firstExpenseRecurrent.date;
          this.endAt = expense.endAt;
          this.quantity = this.getQuantity(this.date);
          this.description = expense.description;
          this.expenseTags = expense.expenseTags;
        }

        this.setWatchers();
        this.emitChangeExpense();
      }
    }
  }
</script>

<style scoped>
  .expense {
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

  .add-select-multi {
    height: 42px;
  }
</style>
