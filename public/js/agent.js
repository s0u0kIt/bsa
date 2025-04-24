class Agent {
  constructor() {
    this.modal = document.getElementById("dataModal");
    this.fields = [
      "dataId",
      "dataLastName",
      "dataFirstName",
      "dataPhone",
      "dataLogin",
      "dataRole",
    ];
    this.submitButton = document.getElementById("submitDataButton");
    this.deleteButton = document.getElementById("deleteDataButton");
    this.dataTableBody = document.querySelector("#dataTable tbody");
    this.searchInput = document.querySelector("#searchData");
    this.isEditing = false;

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

    // Refresh the agents when the page loads or after any changes
    document.addEventListener("DOMContentLoaded", this.refreshData.bind(this));
  }

  /**
   * Toggles the agent form modal and optionally populates it with data.
   * @param {Object} [data] - Data to populate the form fields (optional).
   */
  toggleDataModal(data = {}) {
    // Populate or reset form fields
    this.fields.forEach((field) => {
      document.getElementById(field).value = data[field] || "";
    });

    // Update modal elements based on the presence of data
    this.isEditing = Boolean(data.dataId);
    document.getElementById("dataModalTitle").textContent = this.isEditing
      ? "Modifier un agent"
      : "Ajouter un agent";
    document.getElementById("dataModalDescription").textContent = this.isEditing
      ? "Mettez à jour les informations de l'agent."
      : "Remplissez les informations ci-dessous pour ajouter un nouvel agent.";
    document.getElementById("submitDataButton").textContent = this.isEditing
      ? "Modifier"
      : "Ajouter";
    document.getElementById("dataId").parentElement.hidden = !this.isEditing;

    // Toggle modal visibility
    this.modal.hasAttribute("open")
      ? this.modal.close()
      : this.modal.showModal();
  }

  /**
   * Displays agent information in the modal when a table row is clicked.
   * @param {Event} event - The click event.
   */
  displayData(event) {
    const interactiveTags = ["INPUT", "BUTTON"];
    if (interactiveTags.includes(event.target.tagName)) return;

    const row = event.currentTarget;
    const data = {
      dataId: row.querySelector(".thId").textContent.trim(),
      dataLastName: row.querySelector(".tdLastName").textContent.trim(),
      dataFirstName: row.querySelector(".tdFirstName").textContent.trim(),
      dataPhone: row.querySelector(".tdPhone").textContent.trim(),
      dataLogin: row.querySelector(".tdLogin").textContent.trim(),
      dataRole: row.querySelector(".tdRole").textContent.trim(),
    };

    this.toggleDataModal(data);
  }

  /** Clears the agent form fields. */
  clearDataModal() {
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
   * Filters agents based on search query.
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
      const dataPhone =
        row.querySelector(".tdPhone")?.textContent.toLowerCase() || "";
      const dataLogin =
        row.querySelector(".tdLogin")?.textContent.toLowerCase() || "";

      row.style.display =
        dataId.includes(searchQuery) ||
        dataLastName.includes(searchQuery) ||
        dataFirstName.includes(searchQuery) ||
        dataPhone.includes(searchQuery) ||
        dataLogin.includes(searchQuery)
          ? ""
          : "none";
    });
  }

  /**
   * Refreshes the agent list table.
   */
  async refreshData() {
    try {
      const data = await this.getAllData();
      this.dataTableBody.innerHTML = ""; // Clear table before inserting new data

      if (!data || data.length === 0) {
        console.warn("No agents found.");
        return;
      }

      data.forEach((data) => {
        const tr = document.createElement("tr");
        tr.className = "odd:bg-white even:bg-gray-50 border-b cursor-pointer";
        tr.setAttribute("onclick", "agentClass.displayData(event)");

        // Creating table cells with escaped text content
        const th = document.createElement("th");
        th.scope = "row";
        th.className = "px-2 py-4 font-medium whitespace-nowrap thId";
        th.textContent = data.idAgent; // Using textContent to escape special characters

        const tdLastName = document.createElement("td");
        tdLastName.className = "px-2 py-4 tdLastName";
        tdLastName.textContent = data.nom; // Using textContent to escape special characters

        const tdFirstName = document.createElement("td");
        tdFirstName.className = "px-2 py-4 tdFirstName";
        tdFirstName.textContent = data.prenom; // Using textContent to escape special characters

        const tdPhone = document.createElement("td");
        tdPhone.className = "px-2 py-4 tdPhone";
        tdPhone.textContent = data.tel; // Using textContent to escape special characters

        const tdLogin = document.createElement("td");
        tdLogin.className = "px-2 py-4 tdLogin";
        tdLogin.textContent = data.login; // Using textContent to escape special characters

        const tdRole = document.createElement("td");
        tdRole.className = "px-2 py-4 tdRole";
        tdRole.textContent = data.role; // Using textContent to escape special characters

        // Append cells to row
        tr.appendChild(th);
        tr.appendChild(tdLastName);
        tr.appendChild(tdFirstName);
        tr.appendChild(tdPhone);
        tr.appendChild(tdLogin);
        tr.appendChild(tdRole);

        // Append row to table body
        this.dataTableBody.appendChild(tr);
      });
    } catch (error) {
      console.error("Error in refreshAgents:", error);
    }
  }

  /** Fetch all agents via API. */
  async getAllData() {
    try {
      const response = await fetch("/api/agents", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
      });

      const result = await response.json();
      if (!result.success) throw new Error(result.message || "Unknown error");
      return result.data;
    } catch (error) {
      console.error("Error fetching agents:", error);
    }
  }

  /**
   * Adds a new agent via API.
   */
  async addData(event) {
    event.preventDefault();
    this.toggleSubmitButton();

    const dataId = document.getElementById("dataId").value;
    const dataLastName = document.getElementById("dataLastName").value;
    const dataFirstName = document.getElementById("dataFirstName").value;
    const dataPhone = document.getElementById("dataPhone").value;
    const dataLogin = document.getElementById("dataLogin").value;
    const dataRole = document.getElementById("dataRole").value;

    if (!dataLastName || !dataFirstName || !dataPhone || !dataLogin)
      return alert("Tous les champs doivent être remplis !");

    if (this.isEditing) {
      const inputs = {
        dataId: dataId,
        dataLastName: dataLastName,
        dataFirstName: dataFirstName,
        dataPhone: dataPhone,
        dataLogin: dataLogin,
        dataRole: dataRole,
      };
      this.updateData(inputs);
      return;
    }

    try {
      const response = await fetch("/api/agent", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          nom: dataLastName, // Assumons que 'dataLastName' contient le nom
          prenom: dataFirstName, // Assumons que 'dataFirstName' contient le prénom
          tel: dataPhone,
          login: dataLogin,
          role: dataRole,
        }),
      });

      if (!response.ok) throw new Error("Failed to add agent");
      this.toggleDataModal();
      this.refreshData();
      notifyPopup("success", "L'agent a bien été ajouté");
    } catch (error) {
      notifyPopup(
        "error",
        "Erreur lors de l'ajout, veuillez vérifier vos informations"
      );
    }
    this.toggleSubmitButton();
  }

  /**
   * Updates a new agent via API.
   */
  async updateData(inputs) {
    try {
      const response = await fetch("/api/agent", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          idAgent: inputs.dataId,
          nom: inputs.dataLastName,
          prenom: inputs.dataFirstName,
          tel: inputs.dataPhone,
          login: inputs.dataLogin,
          role: inputs.dataRole,
        }),
      });

      if (!response.ok) throw new Error("Failed to update agent");
      this.toggleDataModal();
      this.refreshData();
      notifyPopup("success", "L'agent a bien été modifié");
    } catch (error) {
      notifyPopup(
        "error",
        "Erreur lors de la modification, veuillez vérifier vos informations"
      );
    }
    this.toggleSubmitButton();
  }

  /**
   * Deletes an agent via API.
   */
  async deleteData() {
    this.toggleDeleteButton();

    const confirmDelete = confirm(
      "Êtes-vous sûr de vouloir supprimer cet agent ?"
    );

    const dataId = document.getElementById("dataId").value;
    if (!dataId || !confirmDelete) {
      this.toggleDeleteButton();
      return;
    }

    try {
      await fetch(`/api/agent/`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ idAgent: dataId }),
      });
      this.toggleDataModal();
      this.refreshData();
      notifyPopup("success", "L'agent a bien été supprimé");
    } catch (error) {
      notifyPopup("error", "Erreur lors de la suppression de l'agent");
    }
    this.toggleDeleteButton();
  }
}

// Initialize class
let agentClass;
document.addEventListener("DOMContentLoaded", () => {
  agentClass = new Agent();
});
