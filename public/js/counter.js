class Counter {
  constructor() {
    this.submitButton = document.getElementById("submitDataButton");
    this.deleteButton = document.getElementById("deleteDataButton");
    this.input = document.getElementById("quick-counter");
    this.increaseBtn = document.getElementById("quick-counter-increase");
    this.decreaseBtn = document.getElementById("quick-counter-decrease");

    // Initialisation des événements
    this.initializeEvents();
    this.initializeCounter();
  }

  /**
   * Initialize event listeners for buttons and other elements.
   */
  initializeEvents() {
    // Boutons d'incrémentation et décrémentation
    this.increaseBtn.addEventListener("click", () => {
      const currentValue = parseInt(this.input.value) || 0;
      this.updateValue(currentValue + 1);
    });

    this.decreaseBtn.addEventListener("click", () => {
      const currentValue = parseInt(this.input.value) || 0;
      this.updateValue(currentValue - 1);
    });

    // Mise à jour du compteur lors de la saisie manuelle
    this.input.addEventListener("input", () => {
      const currentValue = parseInt(this.input.value) || 0;
      this.updateValue(currentValue);
    });
  }

  /**
   * Initialize the counter value from localStorage or default it to 0.
   */
  initializeCounter() {
    const savedValue = localStorage.getItem("quickCounterValue");
    this.input.value = savedValue !== null ? savedValue : 0;
  }

  /**
   * Reset counter
   */
  resetCounter(count = 0) {
    this.input.value = count;
    localStorage.setItem("quickCounterValue", count);
  }

  /** Toggles the submit button's disabled state. */
  toggleSubmitButton() {
    this.submitButton.toggleAttribute("disabled");
  }

  /**
   * Update the input value and save it to localStorage, ensuring it stays in range [0, 500].
   * @param {number} newValue
   */
  updateValue(newValue) {
    // S'assurer que la valeur reste dans l'intervalle [0, 500]
    const clampedValue = Math.max(0, Math.min(500, newValue));
    this.input.value = clampedValue;
    localStorage.setItem("quickCounterValue", clampedValue);
  }

  /**
   * Adds a new count via API.
   */
  async addData(event) {
    event.preventDefault();

    const dataIdZone = document.getElementById("dataIdZone").value;
    const dataCount = document.getElementById("quick-counter").value;

    if (!dataIdZone || !dataCount)
      return alert("Certains champs doivent être remplis !");

    this.toggleSubmitButton();

    try {
      const response = await fetch("/api/comptage", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          // Assumons que les 'data***' contient les données correspondantes :
          idZone: dataIdZone,
          count: dataCount,
        }),
      });

      if (!response.ok) throw new Error("Failed to add case");

      notifyPopup("success", "Le dossier a bien été ajouté");
      this.resetCounter(0);
      history.back();
    } catch (error) {
      notifyPopup(
        "error",
        "Erreur lors de l'ajout, veuillez vérifier vos informations"
      );
    }
    this.toggleSubmitButton();
  }
}

let counterClass;

// Initialisation de la classe Counter une fois que le DOM est chargé
document.addEventListener("DOMContentLoaded", () => {
  counterClass = new Counter();
});