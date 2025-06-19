import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loader"
export default class extends Controller {
  static targets = ["loader"]

  connect() {
  }

  displayLoader() {
    this.loaderTarget.style.display = "inline-flex";
  }
}
