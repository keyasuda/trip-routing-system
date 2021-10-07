import L from 'leaflet'

const initialize = (target) => {
  const map = L.map(target)
  L.tileLayer('http://localhost:8001/tile/{z}/{x}/{y}.png', {
    attribution:
      'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 18,
  }).addTo(map)

  return map
}
export default initialize
