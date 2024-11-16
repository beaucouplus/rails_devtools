import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  toggle() {
    this.checkboxTarget.checked = !this.checkboxTarget.checked
  }
}
