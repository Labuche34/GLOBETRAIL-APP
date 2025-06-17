import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="redirect"
export default class extends Controller {
  connect() {
  }
  
  go(event) {
    const url = event.target.value
    if (url) window.location = url
  }
}
