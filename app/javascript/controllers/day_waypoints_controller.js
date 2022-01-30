import { Controller } from '@hotwired/stimulus'
import { Sortable, MultiDrag } from 'sortablejs'
Sortable.mount(new MultiDrag())

export default class extends Controller {
  static targets = ['list']
  static values = {}

  connect() {
    const sortable = Sortable.create(this.listTarget, {
      animation: 150,
      group: 'shared',
      handle: '.handle',
      multiDrag: true,
      selectedClass: 'selected',
      onEnd: (e) => {
        const payload = {
          to: {
            day_id: e.to.dataset.id,
            waypoints: Array.prototype.slice
              .call(e.to.querySelectorAll('li.waypoint'))
              .map((e) => e.dataset.id),
          },
        }
        if (e.to != e.from) {
          payload.from = {
            day_id: e.from.dataset.id,
            waypoints: Array.prototype.slice
              .call(e.from.querySelectorAll('li.waypoint'))
              .map((e) => e.dataset.id),
          }
        }

        document.querySelector('#waypoints_order').value = JSON.stringify(
          payload
        )

        document.querySelector('#waypoints-order-form').requestSubmit()
      },
    })
  }
}
