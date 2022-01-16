import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['poi']

  connect() {
    const onClick = (ev) => {
      const target = ev.target
      const lat = target.dataset.lat
      const lon = target.dataset.lon

      window.map.setView([lat, lon])
      document.querySelector('#waypoint-name').value = target.innerText
    }

    Array.prototype.slice
      .call(this.poiTargets)
      .map((e) => e.addEventListener('click', onClick))

    if (this.poiTargets.length > 0) {
      this.poiTargets[0].click()
    }
  }
}
