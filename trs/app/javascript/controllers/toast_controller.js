import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['autoclose']

  connect() {
    setTimeout(() => this.autocloseTarget.remove(), 3000)
  }
}
