import { Controller } from '@hotwired/stimulus'
import L from 'leaflet'
import 'polyline-encoded'

export default class extends Controller {
  static targets = ['map']
  static values = { waypoints: Array, routes: Array }

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

    // routes
    this.routesValue.map((route) => {
      const coordinates = L.Polyline.fromEncoded(route.shape, 6)
        .getLatLngs()
        .map((c) => [c.lat / 10, c.lng / 10])

      L.polyline(coordinates, {
        color: 'blue',
        weight: 2,
        opacity: 1,
        lineJoin: 'round',
      }).addTo(map)
    })
  }

  reset() {
    this.map.setView([35, 135], 16)
  }
}
