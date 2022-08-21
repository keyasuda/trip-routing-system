import L from 'leaflet'

const initialize = (target, endpoint, attribution) => {
  const map = L.map(target)
  L.tileLayer(endpoint, {
    attribution: attribution,
    maxZoom: 18,
  }).addTo(map)

  return map
}
export default initialize
