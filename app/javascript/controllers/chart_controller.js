import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto';

// Connects to data-controller="chart"
export default class extends Controller {

  static targets = [ 'chart' ]

  static values = {
    category: Array,
    spendings: Array
  }

  connect() {
    const ctx = this.chartTarget.getContext('2d');
    this.chart = new Chart(ctx,
    {
      type: 'bar',
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
        labels: this.categoryValue,
        datasets: [
          {
            label: 'Acquisitions by year',
            data: this.spendingsValue
          }
        ]
      }
    });
  }

}
