import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['poi']

  connect() {
    if (this.poiTargets.length > 0) {
      this.poiTargets[0].click()
    }
  }

  select(e) {
    const lat = e.target.dataset.lat
    const lon = e.target.dataset.lon

    window.map.setView([lat, lon])
    document.querySelector('#waypoint-name').value = e.target.innerText
  }
}
