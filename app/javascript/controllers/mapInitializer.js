import L from 'leaflet'

const initialize = (target, endpoint) => {
  const map = L.map(target)
  L.tileLayer(endpoint + '/tile/{z}/{x}/{y}.png', {
    attribution:
      'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 18,
  }).addTo(map)

  return map
}
export default initialize
