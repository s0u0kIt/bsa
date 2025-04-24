class Map {
  constructor(mapId, minZoom, maxZoom, initialCoordinates, zoomLevel) {
    this.map = L.map(mapId, { minZoom: minZoom, maxZoom: maxZoom }).setView(
      initialCoordinates,
      zoomLevel
    );
    this.startPoint = null;
    this.currentPoint = null;
    this.tempRectangle = null;
    this.isSelecting = false;
    this.type = "zone";

    // Square meter value
    this.squareMeter = 1000;

    // Density levels for colouring zones
    this.densityLevels = [
      { min: 0, max: 0, color: "#86efac" },
      { min: 1, max: 2, color: "#eab308" },
      { min: 2, max: 4, color: "#f97316" },
      { min: 4, max: 8, color: "#dc2626" },
      { min: 8, max: Infinity, color: "#450a0a" },
    ];

    // Zooms thresholds for zones display
    this.zoneZoomThreshold = 14;
    this.townZoomThreshold = 11;
    this.isleZoomThreshold = 8;
    this.archipelagoZoneZoomThreshold = 6;

    // Define max bounds
    var southWest = L.latLng(-37.543262405611586, -175.9222306014029);
    var northEast = L.latLng(20.3461807551438, -117.38707395866702);
    var bounds = L.latLngBounds(southWest, northEast);

    this.map.setMaxBounds(bounds);

    // Récupérer les modaux
    this.confirmModal = document.getElementById("confirmModal");
    this.infoModal = document.getElementById("nameModal");

    this.initializeMap();

    this.zoneLayerGroup = L.layerGroup().addTo(this.map);
    this.zoneNumberLayerGroup = L.layerGroup().addTo(this.map);
    this.townLayerGroup = L.layerGroup().addTo(this.map);
    this.isleLayerGroup = L.layerGroup().addTo(this.map);
    this.archipelagoLayerGroup = L.layerGroup().addTo(this.map);
  }

  // Initialisation de la carte
  initializeMap() {
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(this.map);
  }

  // Activer le mode de dessin d'une zone
  enableZoneDrawing() {
    this.isSelecting = true;

    // Réinitialiser les variables et retirer tout rectangle précédent
    this.startPoint = null;
    if (this.tempRectangle) {
      this.map.removeLayer(this.tempRectangle);
    }
    this.tempRectangle = null;

    // Désactiver le déplacement sur la carte
    this.map.dragging.disable();

    alert("Cliquez et maintenez pour dessiner une zone !");

    // Activer l'écoute des événements de la carte
    this.map.on("mousedown", this.startDrawing.bind(this));
    this.map.on("mousemove", this.updateDrawing.bind(this));
    this.map.on("mouseup", this.stopDrawing.bind(this));
  }

  // Démarrer le dessin d'une zone
  startDrawing(event) {
    if (this.isSelecting) {
      this.startPoint = event.latlng;

      this.tempRectangle = L.rectangle([this.startPoint, this.startPoint], {
        color: "#ff7800",
        weight: 2,
        fillOpacity: 0.2,
      }).addTo(this.map);
    }
  }

  // Mettre à jour le rectangle temporaire en fonction des mouvements de la souris
  updateDrawing(event) {
    if (!this.startPoint) return;

    this.currentPoint = event.latlng;
    this.tempRectangle.setBounds([this.startPoint, this.currentPoint]);
  }

  // Arrêter le dessin et finaliser la zone
  async stopDrawing() {
    this.isSelecting = false;
    // Réactiver le déplacement de la carte et désactiver les événements
    this.map.dragging.enable();
    this.map.off("mousedown", this.startDrawing.bind(this));
    this.map.off("mousemove", this.updateDrawing.bind(this));
    this.map.off("mouseup", this.stopDrawing.bind(this));

    // Vérifier la superposition des zones
    if (this.checkOverlap(this.startPoint, this.currentPoint)) {
      alert(
        "La nouvelle zone chevauche une déjà existante. Veuillez redessiner votre zone sans toucher une autre."
      );
      // Supprimer le rectangle temporaire
      this.map.removeLayer(this.tempRectangle);
      this.tempRectangle = null;
      // Réinitialiser l'état
      this.startPoint = null;
      this.currentPoint = null;
      return;
    } else {
      if (!this.startPoint || !this.currentPoint) return;
    }

    // Afficher le modal de confirmation
    const confirmed = await this.showConfirmModal();
    if (!confirmed) {
      this.map.removeLayer(this.tempRectangle);
      this.tempRectangle = null;
      this.startPoint = null;
      this.currentPoint = null;
      return;
    }

    // Afficher le modal de saisie du nom de la zone
    const zoneInfo = await this.showInfoModal();
    if (!zoneInfo.name || !zoneInfo.town) {
      this.map.removeLayer(this.tempRectangle);
      this.tempRectangle = null;
      this.startPoint = null;
      this.currentPoint = null;
      return;
    }

    try {
      const added = await this.addData(
        this.type, // Refers to default zone type
        zoneInfo.name ?? "Inconnu",
        this.startPoint.lat,
        this.startPoint.lng,
        this.currentPoint.lat,
        this.currentPoint.lng,
        zoneInfo.town
      );
    } catch (error) {}

    // Supprimer le rectangle temporaire
    if (this.tempRectangle) {
      this.map.removeLayer(this.tempRectangle);
      this.tempRectangle = null;
    }

    // Réinitialiser l'état
    this.startPoint = null;
    this.currentPoint = null;
  }

  // Afficher le modal de confirmation
  showConfirmModal() {
    return new Promise((resolve) => {
      const confirmButton = this.confirmModal.querySelector(".confirm");
      const cancelButton = this.confirmModal.querySelector(".cancel");

      confirmButton.onclick = () => {
        this.confirmModal.close();
        resolve(true);
      };

      cancelButton.onclick = () => {
        this.confirmModal.close();
        resolve(false);
      };

      this.confirmModal.showModal();
    });
  }

  // Afficher le modal de saisie du nom de la zone et de la commune
  showInfoModal() {
    return new Promise((resolve) => {
      const confirmButton = this.infoModal.querySelector(".confirm");
      const cancelButton = this.infoModal.querySelector(".cancel");
      const zoneNameInput = this.infoModal.querySelector("#zoneName");
      const zoneTownSelect = this.infoModal.querySelector("#zoneTown"); // Sélection du <select>

      confirmButton.onclick = () => {
        const zoneName = zoneNameInput.value.trim();
        const zoneTown = zoneTownSelect.value; // Récupérer la valeur sélectionnée

        // Vérifier que les champs ne sont pas vides
        if (zoneName && zoneTown) {
          this.infoModal.close();
          resolve({ name: zoneName, town: zoneTown }); // Renvoyer un objet avec name et town
        } else {
          alert(
            "Veuillez saisir un nom et sélectionner une commune pour la zone."
          );
        }
      };

      cancelButton.onclick = () => {
        this.infoModal.close();
        resolve(null); // Renvoyer null si l'utilisateur annule
      };

      this.infoModal.showModal();
    });
  }

  // Vérifier la superposition des zones
  checkOverlap(startPoint, endPoint) {
    const newBounds = L.latLngBounds(startPoint, endPoint);
    let overlap = false;

    this.zoneLayerGroup.eachLayer((layer) => {
      if (layer instanceof L.Rectangle) {
        const existingBounds = layer.getBounds();
        if (
          newBounds.overlaps(existingBounds) ||
          newBounds.intersects(existingBounds)
        ) {
          overlap = true;
        }
      }
    });

    return overlap;
  }

  /**
   * Adds a new zone via API.
   */
  async addData(type, lib, lat_1, long_1, lat_2, long_2, idParent) {
    try {
      const response = await fetch("/api/zone", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          type: type,
          lib: lib,
          lat_1: lat_1,
          long_1: long_1,
          lat_2: lat_2,
          long_2: long_2,
          idParent: idParent,
        }),
      });

      if (!response.ok) throw new Error("Failed to add zone");

      notifyPopup("success", "La zone a bien été ajoutée");
      this.refreshData();
      return true;
    } catch (error) {
      notifyPopup(
        "error",
        "Erreur lors de l'ajout, veuillez vérifier vos informations"
      );
      return false;
    }
  }

  // Update zones visibility based on zoom level
  updateZoneVisibility = () => {
    const currentZoom = this.map.getZoom();

    // Définir les seuils de zoom pour chaque catégorie
    const zoomThresholds = {
      zone: this.zoneZoomThreshold,
      town: this.townZoomThreshold,
      isle: this.isleZoomThreshold,
      archipelago: this.archipelagoZoneZoomThreshold,
    };

    // Déterminer quelle couche doit être visible en fonction du zoom actuel
    let visibleLayerGroup = null;
    if (currentZoom >= zoomThresholds.zone) {
      visibleLayerGroup = this.zoneLayerGroup;
    } else if (currentZoom >= zoomThresholds.town) {
      visibleLayerGroup = this.townLayerGroup;
    } else if (currentZoom >= zoomThresholds.isle) {
      visibleLayerGroup = this.isleLayerGroup;
    } else if (currentZoom >= zoomThresholds.archipelago) {
      visibleLayerGroup = this.archipelagoLayerGroup;
    }

    // Masquer toutes les couches sauf celle qui doit être visible
    const allLayerGroups = [
      this.zoneLayerGroup,
      this.zoneNumberLayerGroup, // Ajout de la couche des numéros de zone
      this.townLayerGroup,
      this.isleLayerGroup,
      this.archipelagoLayerGroup,
    ];

    allLayerGroups.forEach((layerGroup) => {
      layerGroup.eachLayer((layer) => {
        if (layerGroup === visibleLayerGroup) {
          layer.addTo(this.map); // Afficher la couche si elle correspond au zoom actuel
        } else {
          layer.remove(); // Masquer la couche sinon
        }
      });
    });
  };

  drawZone(zone) {
    const startPoint = L.latLng(zone.lat_1, zone.long_1);
    const endPoint = L.latLng(zone.lat_2, zone.long_2);

    // Calcul de la surface réelle en m²
    const area = this.calculateArea(
      zone.lat_1,
      zone.long_1,
      zone.lat_2,
      zone.long_2
    );

    // Calcul de la densité pour `this.squareMeter`
    const density = (zone.dernier_comptage / area) * this.squareMeter;

    // Trouver la couleur correspondante
    const densityLevel = this.densityLevels.find(
      (level) => density >= level.min && density <= level.max
    );

    const color = densityLevel ? densityLevel.color : "#000000"; // Noir si non trouvé

    // Dessiner la zone avec la bonne couleur
    const rectangle = L.rectangle([startPoint, endPoint], {
      color,
      weight: 2,
      fillOpacity: 0.2,
    });

    // Calcul du centre et placement du marker
    const centerLat = (parseFloat(zone.lat_1) + parseFloat(zone.lat_2)) / 2;
    const centerLng = (parseFloat(zone.long_1) + parseFloat(zone.long_2)) / 2;
    const centerPoint = L.latLng(centerLat, centerLng);

    const numberIcon = L.divIcon({
      className: "number-icon",
      html: `<div class="font-semibold border border-black rounded-full bg-white h-full items-center justify-center flex" style="border: 3px solid ${color};">${zone.dernier_comptage}</div>`,
      iconSize: [30, 30],
      iconAnchor: [15, 15],
    });

    const marker = L.marker(centerPoint, { icon: numberIcon });

    marker.bindPopup(() => this.createPopupContent(zone));

    this.zoneLayerGroup.addLayer(rectangle);
    this.zoneLayerGroup.addLayer(marker);
  }

  calculateArea(lat1, lng1, lat2, lng2) {
    const R = 6378137; // Rayon moyen de la Terre en mètres

    const latDiff = Math.abs(lat1 - lat2) * (Math.PI / 180) * R;
    const lngDiff =
      Math.abs(lng1 - lng2) *
      (Math.PI / 180) *
      R *
      Math.cos(lat1 * (Math.PI / 180));

    return latDiff * lngDiff; // Surface en m²
  }

  drawOtherZone(zone) {
    // Cancel zone drawing if no center is defined
    if (!zone.lat_center || !zone.long_center) {
      return;
    }

    // Create custom number icon
    const numberIcon = L.divIcon({
      className: "number-icon", // Classe CSS pour le style
      html: `<div class="font-semibold border border-black rounded-full bg-white h-full items-center justify-center flex">${zone.dernier_comptage}</div>`, // Le nombre affiché
      iconSize: [30, 30], // Taille de l'icône
      iconAnchor: [15, 15], // Centre de l'icône
    });

    // Add marker on the map
    const marker = L.marker([zone.lat_center, zone.long_center], {
      icon: numberIcon,
    });

    // Bind a popup to display the zone name when clicked
    marker.bindPopup(() => {
      return this.createPopupContent(zone);
    });

    // Add both rectangle and marker to the zoneLayerGroup
    switch (zone.type) {
      case "commune":
        this.townLayerGroup.addLayer(marker);
        break;
      case "ile":
        this.isleLayerGroup.addLayer(marker);
        break;
      case "archipel":
        this.archipelagoLayerGroup.addLayer(marker);
        break;
      default:
        return;
    }
  }

  // Fetch all zones from the API and display them on the map
  async refreshData() {
    try {
      const data = await this.getAllData();

      // Clear previous zones from the map
      this.zoneLayerGroup.clearLayers(); // Clear the layer group before adding new zones
      this.townLayerGroup.clearLayers(); // Clear the layer group before adding new zones
      this.isleLayerGroup.clearLayers(); // Clear the layer group before adding new zones
      this.archipelagoLayerGroup.clearLayers(); // Clear the layer group before adding new zones

      if (!data || data.length === 0) {
        console.warn("No zones found.");
        return;
      }

      // Listen for zoom changes
      this.map.on("zoomend", this.updateZoneVisibility);

      // Draw each zone from the data
      data.forEach((zone) => {
        // Return if the data is not a zone
        if (zone.type == "zone") {
          this.drawZone(zone);
        } else if (["archipel", "ile", "commune"].includes(zone.type)) {
          this.drawOtherZone(zone);
        }
      });

      // Initial visibility check
      this.updateZoneVisibility();
    } catch (error) {
      console.error("Error in refreshData:", error);
    }
  }

  // Fetch all zones from the API
  async getAllData() {
    try {
      const response = await fetch("/api/zones/active", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
      });

      const result = await response.json();
      if (!result.success) throw new Error(result.message || "Unknown error");
      return result.data;
    } catch (error) {
      console.error("Error fetching zones:", error);
    }
  }

  /**
   * Deletes an agent via API.
   */
  async deleteData(event) {
    const confirmDelete = confirm(
      "Êtes-vous sûr de vouloir supprimer ce rapport ?"
    );
    if (!confirmDelete) return;

    const button = event.target;
    const parent = button.parentElement;
    const input = parent.querySelector("input.dataId");
    const dataId = input.value;
    if (!dataId) return;

    try {
      await fetch(`/api/zone/`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ idZone: dataId }),
      });

      notifyPopup("success", "La zone a bien été supprimée");
      this.refreshData();
    } catch (error) {
      notifyPopup("error", "Erreur lors de la suppression de la zone");
    }
  }

  // Fonction pour créer le contenu du popup
  createPopupContent(zone) {
    // Créer un div pour contenir les éléments de la popup
    const popupContent = document.createElement("div");

    // Créer l'input pour idZone (caché)
    const inputId = document.createElement("input");
    inputId.classList.add("dataId");
    inputId.type = "number";
    inputId.value = zone.idZone;
    inputId.hidden = true;

    // Créer un paragraphe pour lib
    const label = document.createElement("h3");
    label.textContent = zone.lib; // Utilisation de textContent pour échapper le texte
    // Créer un paragraphe pour lib
    const count = document.createElement("p");
    count.textContent = "Dernier recensement: " + zone.dernier_comptage; // Utilisation de textContent pour échapper le texte

    // Ajouter les éléments dans le div
    popupContent.appendChild(inputId);
    popupContent.appendChild(label);
    popupContent.appendChild(count);

    // Créer un bouton de suppression
    if (zone.type == "zone") {
      const deleteButton = document.createElement("button");
      deleteButton.textContent = "Supprimer"; // Utilisation de textContent
      deleteButton.style.backgroundColor = "#e74c3c";
      deleteButton.style.color = "white";
      deleteButton.style.border = "none";
      deleteButton.style.padding = "8px 12px";
      deleteButton.style.borderRadius = "5px";
      deleteButton.style.cursor = "pointer";
      deleteButton.addEventListener("click", (event) =>
        mapClass.deleteData(event)
      );
      popupContent.appendChild(deleteButton);
    }

    return popupContent;
  }
}

// Utilisation de la classe
let mapClass;
document.addEventListener("DOMContentLoaded", () => {
  mapClass = new Map("map", 6, 18, [-17.535, -149.569595], 13);
  mapClass.refreshData();
});
