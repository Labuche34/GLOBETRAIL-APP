import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chart"
export default class extends Controller {
  static values = {
    category: String,
    spendings: String
  }
  connect() {
    console.log(this.categoryValue)
    console.log(this.spendingsValue)
  }
}
