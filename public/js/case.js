class Personne {
  constructor() {
    this.modal = document.getElementById("dataModal");
    this.fields = [
      "dataId",
      "dataResidence",
      "dataDateCreation",
      "dataLastName",
      "dataFirstName",
      "dataBorn",
      "dataDn",
      "dataGenre",
      "dataAct",
      "dataEmail",
      "dataPhone",
      "dataChild",
      "dataTypo",
      "dataIdTuteur",
      "dataIdIle",
    ];
    this.submitButton = document.getElementById("submitDataButton");
    this.deleteButton = document.getElementById("deleteDataButton");
    this.dataTableBody = document.querySelector("#dataTable tbody");
    this.searchInput = document.querySelector("#searchData");
    this.isEditing = false;

    this.initializeEvents();
  }

  /**
   * Initialize event listeners
   */
  initializeEvents() {
    if (this.searchInput) {
      this.searchInput.addEventListener("input", (e) => this.filterData(e));
    }

    document.addEventListener("DOMContentLoaded", () => this.refreshData());
  }

  /**
   * Clears all the fields of the data modal form
   */
  clearDataModal() {
    const form = this.modal.querySelector("#dataForm");
    const id = form.querySelector("#dataId").value;
    const dateCreation = form.querySelector("#dataDateCreation").value;

    form.reset();
    form.querySelector("#dataId").value = id;
    form.querySelector("#dataDateCreation").value = dateCreation;
  }

  /**
   * Toggle the modal and populate it with data if provided
   * @param {Object} [data] - Data to populate the form fields (optional)
   */
  toggleDataModal(data = {}) {
    this.fields.forEach((field) => {
      document.getElementById(field).value = data[field] || "";
    });

    this.isEditing = Boolean(data.dataId);
    this.updateModalUI(data.dataId);
    this.toggleModalVisibility();

    if (this.isEditing) reportClass.refreshOneCaseReports(data.dataId);
  }

  /**
   * Update modal UI based on editing state
   * @param {string} id - Case ID (optional)
   */
  updateModalUI(id) {
    const modalTitle = document.getElementById("dataModalTitle");
    const modalDescription = document.getElementById("dataModalDescription");
    const reportsViewer = document.getElementById("reportsViewer");

    modalTitle.textContent = this.isEditing
      ? "Consultation du dossier"
      : "Ajouter le dossier";
    modalDescription.textContent = this.isEditing
      ? "Mettez à jour les informations du dossier."
      : "Remplissez les informations ci-dessous pour ajouter un nouveau dossier.";
    this.submitButton.textContent = this.isEditing ? "Modifier" : "Ajouter";
    this.deleteButton.hidden = !this.isEditing;
    document.getElementById("dataId").parentElement.hidden = !this.isEditing;
    document.getElementById("dataIdTuteur").disabled = this.isEditing;
    document
      .getElementById("reportSection")
      .classList.toggle("hidden", !this.isEditing);
    document.getElementById("dataDateCreation").parentElement.hidden =
      !this.isEditing;
    this.modal.classList.toggle("w-full", this.isEditing);
    this.modal.classList.toggle("w-fit", !this.isEditing);
    reportsViewer.hidden = !this.isEditing;
  }

  /**
   * Toggle modal visibility
   */
  toggleModalVisibility() {
    this.modal.hasAttribute("open")
      ? this.modal.close()
      : this.modal.showModal();
  }

  /**
   * Update modal report char. count
   */
  updateCharCount() {
    const textarea = document.getElementById("dataReport");
    const charCount = document.getElementById("charCount");
    charCount.textContent = textarea.value.length;
  }

  /**
   * Display case data in the modal when a table row is clicked
   * @param {Event} event - The click event
   */
  displayData(event) {
    if (["INPUT", "BUTTON"].includes(event.target.tagName)) return;

    const row = event.currentTarget;
    const data = this.extractRowData(row);
    this.toggleDataModal(data);
  }

  /**
   * Extract data from a table row
   * @param {HTMLElement} row - The table row element
   * @returns {Object} - Extracted data
   */
  extractRowData(row) {
    return {
      dataId: row.querySelector(".thId").textContent.trim(),
      dataResidence: row.querySelector(".tdResidence").textContent.trim(),
      dataDateCreation: row.querySelector(".tdDateCreation").value,
      dataLastName: row.querySelector(".tdLastName").textContent.trim(),
      dataFirstName: row.querySelector(".tdFirstName").textContent.trim(),
      dataBorn: row.querySelector(".tdBorn").value,
      dataDn: row.querySelector(".tdDn").textContent.trim(),
      dataGenre: row.querySelector(".tdGenre").textContent.trim(),
      dataAct: row.querySelector(".tdAct").textContent.trim(),
      dataPhone: row.querySelector(".tdPhone").textContent.trim(),
      dataEmail: row.querySelector(".tdEmail").textContent.trim(),
      dataTypo: row.querySelector(".tdTypo").textContent.trim(),
      dataChild: row.querySelector(".tdChild").textContent.trim(),
      dataIdTuteur: row.querySelector(".tdIdTuteur").textContent.trim(),
      dataIdIle: row.querySelector(".tdIdIle").textContent.trim(),
    };
  }

  /**
   * Filter table rows based on search query
   * @param {Event} event - The search input event
   */
  filterData(event) {
    const searchQuery = event.target.value.toLowerCase();
    const rows = this.dataTableBody.querySelectorAll("tr");

    rows.forEach((row) => {
      const rowText = Array.from(row.querySelectorAll("td, th"))
        .map((cell) => cell.textContent.toLowerCase())
        .join(" ");
      row.style.display = rowText.includes(searchQuery) ? "" : "none";
    });
  }

  /**
   * Refresh the case list table
   */
  async refreshData() {
    try {
      const data = await this.fetchAllData();
      this.dataTableBody.innerHTML = "";

      if (!data || data.length === 0) {
        console.warn("No cases found.");
        return;
      }

      data.forEach((item) => {
        const row = this.createTableRow(item);
        this.dataTableBody.appendChild(row);
      });
    } catch (error) {
      console.error("Error refreshing data:", error);
    }
  }

  /**
   * Create a table row for a case
   * @param {Object} data - Case data
   * @returns {HTMLElement} - Table row element
   */
  createTableRow(data) {
    const row = document.createElement("tr");
    row.className = "odd:bg-white even:bg-gray-50 cursor-pointer";
    switch (data.residence) {
      case "A la rue":
        row.className += " border-2 border-red-300";
        break;
      case "Famille d'accueil - Unité de vie":
        row.className += " border-2 border-green-300";
        break;
      case "Hébergement associatif":
        row.className += " border-2 border-blue-300";
        break;
      default:
        row.className += " border-b";
        break;
    }
    row.setAttribute("onclick", "caseClass.displayData(event)");

    // Create the row elements manually to escape special characters
    const th = document.createElement("th");
    th.scope = "row";
    th.className = "px-2 py-3 font-medium text-gray-900 whitespace-nowrap thId";
    th.textContent = data.idPersonne ?? ""; // Use textContent for escaping

    const tdDateCreation = document.createElement("td");
    tdDateCreation.className = "px-2 py-3";
    const inputDate = document.createElement("input");
    inputDate.type = "date";
    inputDate.value = data.dateCreation ?? "";
    inputDate.className = "bg-transparent tdDateCreation";
    inputDate.disabled = true;
    tdDateCreation.appendChild(inputDate);

    const tdLastName = document.createElement("td");
    tdLastName.className = "px-2 py-3 tdLastName";
    tdLastName.textContent = data.nom ?? ""; // Use textContent for escaping

    const tdFirstName = document.createElement("td");
    tdFirstName.className = "px-2 py-3 tdFirstName";
    tdFirstName.textContent = data.prenom ?? ""; // Use textContent for escaping

    const tdDateNaiss = document.createElement("td");
    tdDateNaiss.className = "px-2 py-3 hidden md:table-cell";
    const inputDateNaiss = document.createElement("input");
    inputDateNaiss.type = "date";
    inputDateNaiss.value = data.dateNaiss ?? "";
    inputDateNaiss.className = "bg-transparent tdBorn";
    inputDateNaiss.disabled = true;
    tdDateNaiss.appendChild(inputDateNaiss);

    const tdResidence = document.createElement("td");
    tdResidence.className = "px-2 py-3 tdResidence hidden";
    tdResidence.textContent = data.residence ?? ""; // Use textContent for escaping

    const tdDn = document.createElement("td");
    tdDn.className = "px-2 py-3 tdDn";
    tdDn.textContent = data.dn ?? ""; // Use textContent for escaping

    const tdGenre = document.createElement("td");
    tdGenre.className = "px-2 py-3 tdGenre hidden";
    tdGenre.textContent = data.genre ?? ""; // Use textContent for escaping

    const tdAct = document.createElement("td");
    tdAct.className = "px-2 py-3 tdAct hidden";
    tdAct.textContent = data.activite ?? ""; // Use textContent for escaping

    const tdPhone = document.createElement("td");
    tdPhone.className = "px-2 py-3 tdPhone";
    tdPhone.textContent = data.tel ?? ""; // Use textContent for escaping

    const tdEmail = document.createElement("td");
    tdEmail.className = "px-2 py-3 hidden md:table-cell tdEmail";
    tdEmail.textContent = data.email ?? ""; // Use textContent for escaping

    const tdTypo = document.createElement("td");
    tdTypo.className = "px-2 py-3 tdTypo";
    tdTypo.textContent = data.typologie ?? ""; // Use textContent for escaping
    tdTypo.hidden = true;

    const tdChild = document.createElement("td");
    tdChild.className = "px-2 py-3 tdChild";
    tdChild.textContent = data.nbEnfant ?? ""; // Use textContent for escaping
    tdChild.hidden = true;

    const tdIdTuteur = document.createElement("td");
    tdIdTuteur.className = "px-2 py-3 tdIdTuteur";
    tdIdTuteur.textContent = data.idTuteur ?? ""; // Use textContent for escaping
    tdIdTuteur.hidden = true;

    const tdIdIle = document.createElement("td");
    tdIdIle.className = "px-2 py-3 tdIdIle";
    tdIdIle.textContent = data.idIle ?? ""; // Use textContent for escaping
    tdIdIle.hidden = true;

    // Append all cells to the row
    row.appendChild(th);
    row.appendChild(tdDateCreation);
    row.appendChild(tdLastName);
    row.appendChild(tdFirstName);
    row.appendChild(tdDateNaiss);
    row.appendChild(tdResidence);
    row.appendChild(tdDn);
    row.appendChild(tdGenre);
    row.appendChild(tdAct);
    row.appendChild(tdPhone);
    row.appendChild(tdEmail);
    row.appendChild(tdTypo);
    row.appendChild(tdChild);
    row.appendChild(tdIdTuteur);
    row.appendChild(tdIdIle);

    return row;
  }

  /**
   * Fetch all cases via API
   * @returns {Promise<Array>} - Array of cases
   */
  async fetchAllData() {
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
   * Add or update a case via API
   * @param {Event} event - The form submission event
   */
  async saveData(event) {
    event.preventDefault();
    this.toggleSubmitButton();

    const formData = this.getFormData();
    if (!formData.dataLastName || !formData.dataFirstName || !formData.dataResidence) {
      alert("Les champs suivie d'un '*' / astérix doivent être indiqués !");
      this.toggleSubmitButton();
      return;
    }

    try {
      const endpoint = this.isEditing ? "/api/dossier" : "/api/dossier";
      const method = this.isEditing ? "PUT" : "POST";
      const body = this.isEditing
        ? { idPersonne: formData.dataId, ...formData }
        : formData;

      const response = await fetch(endpoint, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });

      if (!response.ok) throw new Error("Failed to save case");
      this.toggleDataModal();
      this.refreshData();
      notifyPopup(
        "success",
        `Le dossier a bien été ${this.isEditing ? "modifié" : "ajouté"}`
      );
    } catch (error) {
      notifyPopup(
        "error",
        `Erreur lors de ${this.isEditing ? "la modification" : "l'ajout"}`
      );
    }
    this.toggleSubmitButton();
  }

  /**
   * Adds a new report via API.
   */
  async addReport() {
    const dataId = document.getElementById("dataId").value;
    const dataReport = document.getElementById("dataReport").value;

    document.getElementById("dataReport").value = "";

    if (!dataId || !dataReport) return;

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
      reportClass.refreshOneCaseReports(dataId);
    } catch (error) {
      notifyPopup(
        "error",
        "Erreur lors de l'ajout, veuillez vérifier vos informations"
      );
    }
  }

  /**
   * Delete a case via API
   */
  async deleteData() {
    this.toggleDeleteButton();

    const confirmDelete = confirm(
      "Êtes-vous sûr de vouloir supprimer de dossier ?"
    );

    const dataId = document.getElementById("dataId").value;
    if (!dataId || !confirmDelete) {
      this.toggleDeleteButton();
      return;
    }

    try {
      const response = await fetch(`/api/dossier/`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ id: dataId }),
      });

      if (!response.ok) throw new Error("Failed to delete case");
      this.toggleDataModal();
      this.refreshData();
      notifyPopup("success", "Le dossier a bien été supprimé");
    } catch (error) {
      notifyPopup("error", "Erreur lors de la suppression du dossier");
    }
    this.toggleDeleteButton();
  }

  /**
   * Get form data as an object
   * @returns {Object} - Form data
   */
  getFormData() {
    return this.fields.reduce((data, field) => {
      data[field] = document.getElementById(field).value;
      return data;
    }, {});
  }

  /**
   * Toggle the submit button's disabled state
   */
  toggleSubmitButton() {
    this.submitButton.toggleAttribute("disabled");
  }

  /**
   * Toggle the delete button's disabled state
   */
  toggleDeleteButton() {
    this.deleteButton.toggleAttribute("disabled");
  }
}

// Initialize class
let caseClass;
document.addEventListener("DOMContentLoaded", () => {
  caseClass = new Personne();
});
