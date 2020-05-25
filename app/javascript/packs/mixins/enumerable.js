const DateFormat = {
  BACK_END: "YYYY-MM-DD",
  FRONT_END: "DD/MM/YYYY"
}
Object.freeze(DateFormat)

const CARD_TYPES = {
  Credit: "Credit"
}
Object.freeze(CARD_TYPES)

export default {
  name: "Enumerable",
  data() {
    return {
      DateFormat,
      CARD_TYPES
    }
  }
}
