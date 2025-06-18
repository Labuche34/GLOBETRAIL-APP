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
      type: 'bar',
      options: {
        animation: false,
        plugins: {
          legend: {
            display: false,
            labels: {
              font: {
                size: 12 // ← augmente ici la taille du texte
              },
              color: '#212925'
            },
          },
          tooltip: {
            enabled: false
          }
        },
        formatter: (value, context) => {
          const label = context.chart.data.labels[context.dataIndex]
          return `${label}: €${(value / 100).toFixed(2)}`
        }
      },
      data: {
        labels: Object.keys(this.spendingsValue),
        datasets: [
          {
            label: 'Spendings by category',
            data: Object.values(this.spendingsValue),
            backgroundColor: [
              '#8ecae6', // vert menthe
              '#fb8500', // orange
              '#023047', // bleu foncé
              '#ffb703' // jaune doux
            ],
            hoverOffset: 4
          }
        ]
      }
    });
  }

}
