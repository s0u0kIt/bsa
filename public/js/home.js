class Home {
  constructor(mapId, initialCoordinates, zoomLevel) {
    this.map = L.map(mapId).setView(initialCoordinates, zoomLevel);
    this.initializeMap();
    this.addMarker(initialCoordinates); // Ajout du repère prédéfini
  }

  // Initialisation de la carte
  initializeMap() {
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(this.map);
  }

  // Ajouter un repère prédéfini
  addMarker(coordinates) {
    L.marker(coordinates)
      .addTo(this.map)
      .bindPopup("Bureau en charge des Sans Abris")
      .openPopup();
  }
}

// Utilisation de la classe
document.addEventListener("DOMContentLoaded", () => {
  const mapClass = new Home("map", [-17.539483, -149.563125], 17);
});
