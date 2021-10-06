import { Controller } from '@hotwired/stimulus'
import L from 'leaflet'

export default class extends Controller {
  static targets = ['map']
  static values = { waypoints: Array }

  connect() {
    const map = L.map(this.mapTarget)
    L.tileLayer('http://localhost:8001/tile/{z}/{x}/{y}.png', {
      attribution:
        'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom: 18,
    }).addTo(map)
    this.map = map

    // 全waypointsのマーカーを生成
    const markers = this.waypointsValue.map((w) => {
      const marker = L.marker([w.latitude, w.longitude]).addTo(map)
      marker.bindPopup(w.name)

      return marker
    })
    const group = L.featureGroup(markers)

    map.fitBounds(group.getBounds())
  }

  reset() {
    this.map.setView([35, 135], 16)
  }
}
