# frozen_string_literal: true

# Use direct uploads for Active Storage (remember to import "@rails/activestorage" in your application.js)
# pin "@rails/activestorage", to: "activestorage.esm.js"

# Use npm packages from a JavaScript CDN by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.js'
pin '@hotwired/stimulus', to: 'stimulus.js'
pin '@hotwired/stimulus-importmap-autoloader', to: 'stimulus-importmap-autoloader.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'leaflet', to: 'https://ga.jspm.io/npm:leaflet@1.7.1/dist/leaflet-src.js'
pin 'polyline-encoded', to: 'https://ga.jspm.io/npm:polyline-encoded@0.0.9/Polyline.encoded.js'
