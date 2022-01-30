import { Controller } from '@hotwired/stimulus'
import L from 'leaflet'
import 'polyline-encoded'
import 'leaflet-extra-markers'
import init from './mapInitializer'

export default class extends Controller {
  static targets = ['map']
  static values = { waypoints: Array, routes: Array, endpoint: String }

  connect() {
    const map = init(this.mapTarget, this.endpointValue)
    this.map = map

    // 全waypointsのマーカーを生成
    const markers = this.waypointsValue.map((w, i) => {
      let n = i
      let color = 'blue'
      if (i == 0) {
        n = '始'
        color = 'red'
      }
      if (i == this.waypointsValue.length - 1) {
        n = '終'
        color = 'green'
      }
      const marker = L.marker([w.latitude, w.longitude], {
        icon: L.ExtraMarkers.icon({
          icon: 'fa-number',
          number: n,
          markerColor: color,
        }),
      }).addTo(map)
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
}
