import { Controller } from '@hotwired/stimulus';
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
	static values = { apiKey: String, markers: Array };

	connect() {
		mapboxgl.accessToken = this.apiKeyValue;

		this.map = new mapboxgl.Map({
			container: this.element,
			style: 'mapbox://styles/mapbox/standard-satellite',
			zoom: 1.5,
			center: [-90, 40],
			projection: 'globe',
		});

		this.map.on('style.load', () => {
			this.map.setFog({});
		});

		this.secondsPerRevolution = 120;
		this.maxSpinZoom = 5;
		this.slowSpinZoom = 3;
		this.userInteracting = false;
		this.spinEnabled = true;

		this.#addMarkersToMap();

		// Bind events
		this.map.on('mousedown', () => (this.userInteracting = true));
		this.map.on('mouseup', () => {
			this.userInteracting = false;
			this.spinGlobe();
		});
		this.map.on('dragend', () => {
			this.userInteracting = false;
			this.spinGlobe();
		});
		this.map.on('pitchend', () => {
			this.userInteracting = false;
			this.spinGlobe();
		});
		this.map.on('rotateend', () => {
			this.userInteracting = false;
			this.spinGlobe();
		});
		this.map.on('moveend', () => this.spinGlobe());

		this.spinGlobe();
	}

	#addMarkersToMap() {
		this.markersValue.forEach((marker) => {
			new mapboxgl.Marker().setLngLat([marker.lng, marker.lat]).addTo(this.map);
		});
	}

	spinGlobe() {
		const zoom = this.map.getZoom();

		if (this.spinEnabled && !this.userInteracting && zoom < this.maxSpinZoom) {
			let distancePerSecond = 360 / this.secondsPerRevolution;

			if (zoom > this.slowSpinZoom) {
				const zoomDif =
					(this.maxSpinZoom - zoom) / (this.maxSpinZoom - this.slowSpinZoom);
				distancePerSecond *= zoomDif;
			}

			const center = this.map.getCenter();
			center.lng -= distancePerSecond;

			this.map.easeTo({
				center,
				duration: 1000,
				easing: (n) => n,
			});
		}
	}
}
