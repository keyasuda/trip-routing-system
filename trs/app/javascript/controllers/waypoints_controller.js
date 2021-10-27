import { Controller } from '@hotwired/stimulus'
import L from 'leaflet'
import init from './mapInitializer'

export default class extends Controller {
  static targets = ['map', 'latitude', 'longitude']

  connect() {
    const map = init(this.mapTarget)
    window.map = map

    const lat = this.latitudeTarget.value
    const lng = this.longitudeTarget.value
    map.setView([lat, lng], 15)

    const pin = L.marker(map.getCenter()).addTo(map)

    map.on('move', (ev) => {
      const center = map.getCenter()

      pin.setLatLng(center)
      this.latitudeTarget.value = center.lat
      this.longitudeTarget.value = center.lng
    })
  }
}
