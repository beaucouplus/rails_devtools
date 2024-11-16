import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  reset() {
    this.dispatch("search.reset")
  }
}
