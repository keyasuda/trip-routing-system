import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['poi']

  connect() {
    Array.prototype.slice.call(this.poiTargets).map(
      (e) =>
        (e.onclick = (ev) => {
          const target = ev.target
          const lat = target.dataset.lat
          const lon = target.dataset.lon
          window.map.setView([lat, lon])
        })
    )
  }
}
