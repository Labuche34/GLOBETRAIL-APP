# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "flatpickr" # @4.6.13
pin "flatpickr-css", to: "https://cdn.jsdelivr.net/npm/flatpickr@4.6.13/dist/flatpickr.min.css"
pin "mapbox-gl", to: "https://cdn.jsdelivr.net/npm/mapbox-gl@3.12.0/+esm", preload: true
pin "mapbox-gl-css", to: "https://cdn.jsdelivr.net/npm/mapbox-gl@3.12.0/dist/mapbox-gl.css"
