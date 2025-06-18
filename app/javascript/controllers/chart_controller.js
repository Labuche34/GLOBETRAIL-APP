import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto';

// Connects to data-controller="chart"
export default class extends Controller {

  static targets = [ 'chart' ]

  static values = {
    spendings: Object
  }

  connect() {
    const ctx = this.chartTarget.getContext('2d');
    this.chart = new Chart(ctx,
    {
      type: 'doughnut',
      options: {
        animation: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            enabled: false
          }
        }
      },
      data: {
        labels: Object.keys(this.spendingsValue),
        datasets: [
          {
            label: 'Acquisitions by year',
            data: Object.values(this.spendingsValue),
          }
        ]
      }
    });
  }

}
