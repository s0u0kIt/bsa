class Zone {
  constructor() {
    this.init();
  }

  // Initialization
  init() {}

  /**
   * Add or update a case via API
   * @param {Event} event - The radio button click event
   */
  async saveData(event) {
    if (!event.target || !event.target.hasAttribute('name') || !event.target.hasAttribute('value')) {
      return;
    }

    const idZone = event.target.name;
    const active = event.target.value;

    console.log(idZone, active);

    try {
      const endpoint = "/api/zone/active";
      const method = "PUT";
      const body = { idZone: idZone, active: active };

      const response = await fetch(endpoint, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });

      if (!response.ok) throw new Error("Failed to save zone");
      notifyPopup(
        "success",
        "La zone a bien été modifiée"
      );
    } catch (error) {
      notifyPopup(
        "error",
        "Erreur lors de la modification"
      );
    }
  }

  // Filter zones
  filterData(event) {}

  // Fonction pour déplier/replier les sections
  toggleSection(event) {
    const dropdownSection = event.target.parentElement;
    if (!dropdownSection) {
      return;
    }

    const dropdownContent = dropdownSection.querySelector(".dropdown-content");
    const arrow = dropdownSection.querySelector("svg");
    if (!dropdownContent) {
      return;
    }

    dropdownContent.classList.toggle("hidden");
    arrow.classList.toggle("rotate-90");
  }
}

var zoneClass;
document.addEventListener("DOMContentLoaded", () => {
  zoneClass = new Zone();
});
