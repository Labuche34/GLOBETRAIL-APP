// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import "@popperjs/core"
import "flatpickr"

document.addEventListener("turbo:load", () => {
  flatpickr(".datepicker", {
    altInput: true,
    altFormat: "d/m/Y",
    dateFormat: "Y-m-d"
  });
});
