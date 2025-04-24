class Personne {
  constructor() {
    this.modal = document.getElementById("dataModal");
    this.submitButton = document.getElementById("submitDataButton");
    this.deleteButton = document.getElementById("deleteDataButton");
    this.dataTableBody = document.querySelector("#dataTable tbody");
    this.searchInput = document.querySelector("#searchData");

    // Initialisation des événements
    this.initializeEvents();
  }

  /**
   * Initialize event listeners for buttons and search input
   */
  initializeEvents() {
    // Search filter
    if (this.searchInput) {
      this.searchInput.addEventListener("input", this.filterData.bind(this));
    }
  }

  /** Clears the case form fields. */
  clearForm() {
    document.getElementById("dataForm").reset();
  }

  /** Toggles the submit button's disabled state. */
  toggleSubmitButton() {
    this.submitButton.toggleAttribute("disabled");
  }

  /** Toggles the delete button's disabled state. */
  toggleDeleteButton() {
    this.deleteButton.toggleAttribute("disabled");
  }

  /**
   * Filters cases based on search query.
   * @param {Event} event - The search input event.
   */
  filterData(event) {
    const searchQuery = event.target.value.toLowerCase();
    const rows = this.dataTableBody.querySelectorAll("tr");

    rows.forEach((row) => {
      const dataId =
        row.querySelector(".thId")?.textContent.toLowerCase() || "";
      const dataLastName =
        row.querySelector(".tdLastName")?.textContent.toLowerCase() || "";
      const dataFirstName =
        row.querySelector(".tdFirstName")?.textContent.toLowerCase() || "";
      const dataBorn =
        row.querySelector(".tdBorn")?.textContent.toLowerCase() || "";
      const dataDn =
        row.querySelector(".tdDn")?.textContent.toLowerCase() || "";

      row.style.display =
        dataId.includes(searchQuery) ||
        dataLastName.includes(searchQuery) ||
        dataFirstName.includes(searchQuery) ||
        dataBorn.includes(searchQuery)
          ? ""
          : "none";
    });
  }

  /** Fetch all cases via API. */
  async getAllData() {
    try {
      const response = await fetch("/api/dossiers", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
      });

      const result = await response.json();
      if (!result.success) throw new Error(result.message || "Unknown error");
      return result.data;
    } catch (error) {
      console.error("Error fetching cases:", error);
    }
  }

  displayData(event) {
    const id = event.currentTarget
      .querySelector(".thId")
      .textContent.toLowerCase();
    window.location.assign("/mobile/dossier?id=" + id);
  }

  /**
   * Adds a new person via API.
   */
  async addData(event) {
    event.preventDefault();
    this.toggleSubmitButton();

    const confirmAdd = confirm(
      "Êtes-vous sûr de vouloir enregistrer ce dossier ?"
    );
    const dataLastName = document.getElementById("dataLastName").value;
    const dataFirstName = document.getElementById("dataFirstName").value;
    const dataBorn = document.getElementById("dataBorn").value;
    const dataDn = document.getElementById("dataDn").value;
    const dataResidence = document.getElementById("dataResidence").value;
    const dataGenre = document.getElementById("dataGenre").value;
    const dataAct = document.getElementById("dataAct").value;
    const dataEmail = document.getElementById("dataEmail").value;
    const dataPhone = document.getElementById("dataPhone").value;
    const dataChild = document.getElementById("dataChild").value;
    const dataTypo = document.getElementById("dataTypo").value;
    const dataIdTuteur = document.getElementById("dataIdTuteur").value;
    const dataIdIle = document.getElementById("dataIdIle").value;

    if (!dataLastName || !dataFirstName || !dataResidence)
      return alert("Les champs suivie d'un '*' / astérix doivent être indiqués !");

    if (!confirmAdd) {
      this.toggleSubmitButton();
      return;
    }

    try {
      const response = await fetch("/api/dossier", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          dataResidence: dataResidence,
          dataLastName: dataLastName,
          dataFirstName: dataFirstName,
          dataBorn: dataBorn,
          dataDn: dataDn,
          dataGenre: dataGenre,
          dataAct: dataAct,
          dataPhone: dataPhone,
          dataEmail: dataEmail,
          dataTypo: dataTypo,
          dataChild: dataChild,
          dataIdTuteur: dataIdTuteur,
          dataIdIle: dataIdIle,
        }),
      });
      if (!response.ok) throw new Error("Failed to add case");

      notifyPopup("success", "Le dossier a bien été ajouté");
      window.location.replace("/mobile/dossiers");
    } catch (error) {
      notifyPopup(
        "error",
        "Erreur lors de l'ajout, veuillez vérifier vos informations"
      );
    }
    this.toggleSubmitButton();
  }

  /**
   * Adds a new report via API.
   */
  async addReport(event) {
    event.preventDefault();
    this.toggleSubmitButton();

    const confirmAdd = confirm(
      "Êtes-vous sûr de vouloir enregistrer ce dossier ?"
    );

    const dataId = document.getElementById("dataId").value;
    const dataReport = document.getElementById("dataReport").value;

    if (!dataId || !dataReport)
      return alert("Certains champs doivent être remplis !");

    if (!dataId || !confirmAdd) {
      this.toggleSubmitButton();
      return;
    }

    try {
      const response = await fetch("/api/releve", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          dataId: dataId,
          dataReport: dataReport,
        }),
      });
      if (!response.ok) throw new Error("Failed to add report");

      notifyPopup("success", "Le relevé a bien été ajouté");
      window.location.replace("/mobile");
    } catch (error) {
      notifyPopup(
        "error",
        "Erreur lors de l'ajout, veuillez vérifier vos informations"
      );
    }
    this.toggleSubmitButton();
  }
}

// Initialize class
let caseClass;
document.addEventListener("DOMContentLoaded", () => {
  caseClass = new Personne();
});