import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['container', 'target']
  static values = {}

  connect() {
    const current =
      this.containerTarget.scrollTop -
      this.containerTarget.getBoundingClientRect().y
    const toBe = this.targetTarget.getBoundingClientRect().y

    this.containerTarget.scrollTo(0, current + toBe)
  }
}
