import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.add("opacity-0")
      setTimeout(() => this.element.remove(), 300)
    }, 3000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
