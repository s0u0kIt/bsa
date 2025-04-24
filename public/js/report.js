class Report {
  /**
   * Delete one report via API
   */
  async deleteData(id) {
    // Confirm deletion
    const confirmDelete = confirm(
      "Êtes-vous sûr de vouloir supprimer ce rapport ?"
    );

    const caseId = document.getElementById("dataId").value;

    if (!id || !confirmDelete || !caseId) {
      return;
    }

    try {
      const response = await fetch(`/api/releve/`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ idReleve: id }),
      });

      if (!response.ok) throw new Error("Failed to delete case");
      notifyPopup("success", "Le rapport a bien été supprimé");
      this.refreshOneCaseReports(caseId);
    } catch (error) {
      notifyPopup("error", "Erreur lors de la suppression du rapport");
    }
  }

  /**
   * Refresh reports for a specific case
   * @param {string} id - Case ID
   */
  async refreshOneCaseReports(id) {
    const reportsContainer = document.getElementById("reportsViewer"); // Conteneur d'affichage

    // Vider le conteneur avant d'ajouter les nouveaux rapports
    reportsContainer.innerHTML = "";

    const data = await this.fetchOneCaseReports(id);

    // Toggle download button depending on presence of data
    this.toggleReportDownloadButton(!data);

    if (!data) return;

    data.forEach((report, index) => {
      // Création d'un wrapper div qui sera bien interprété par Quill
      const reportWrapper = document.createElement("div");
      reportWrapper.style.display = "flex";
      reportWrapper.style.alignItems = "center";
      reportWrapper.style.gap = "10px"; // Espacement entre la date et le bouton

      // Date en gras sur une ligne (en utilisant textContent pour éviter les injections)
      const dateElement = document.createElement("p");
      const strongElement = document.createElement("strong");
      strongElement.textContent = `[${new Date(
        report.date
      ).toLocaleDateString()}] par ` + report.agentLastName + ` ` + report.agentFirstName;
      dateElement.appendChild(strongElement);

      // Bouton de suppression
      const deleteButton = document.createElement("button");
      deleteButton.innerHTML = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="red" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="18" y1="6" x2="6" y2="18"></line>
        <line x1="6" y1="6" x2="18" y2="18"></line>
        </svg>`;
      deleteButton.style.border = "none";
      deleteButton.style.background = "transparent";
      deleteButton.style.cursor = "pointer";
      deleteButton.style.fontSize = "16px";
      deleteButton.title = "Supprimer ce rapport";
      deleteButton.type = "button";
      deleteButton.onclick = () => this.deleteData(report.idReleve);

      // Conteneur pour la date et le bouton
      const dateContainer = document.createElement("div");
      dateContainer.style.display = "flex";
      dateContainer.style.alignItems = "center";
      dateContainer.style.gap = "5px"; // Espacement entre date et bouton
      dateContainer.appendChild(dateElement);
      dateContainer.appendChild(deleteButton);

      // Commentaire sécurisé avec gestion des retours à la ligne
      const commentElement = document.createElement("div");
      report.commentaire.split("\n").forEach((line) => {
        const paragraph = document.createElement("p");
        paragraph.textContent = line;
        paragraph.style.wordBreak = "break-all";
        commentElement.appendChild(paragraph);
      });

      // Ajout des éléments dans le wrapper
      reportWrapper.appendChild(dateContainer);
      reportWrapper.appendChild(commentElement);

      // Ajout au conteneur
      reportsContainer.appendChild(reportWrapper);

      // Ajouter un espace entre chaque rapport sauf le dernier
      if (index < data.length - 1) {
        const spacer = document.createElement("p");
        spacer.innerHTML = "<br>"; // Quill interprétera cela comme un saut de ligne
        reportsContainer.appendChild(spacer);
      }
    });
  }

  /**
   * Fetch reports for a specific case via API
   * @param {string} id - Case ID
   * @returns {Promise<Array>} - Array of reports
   */
  async fetchOneCaseReports(id) {
    try {
      const response = await fetch(`/api/releves?id=${id}`, {
        method: "GET",
        headers: { "Content-Type": "application/json" },
      });
      const result = await response.json();
      if (!result.success) throw new Error(result.message || "Unknown error");
      return result.data;
    } catch (error) {
      console.error("Error fetching reports:", error);
    }
  }

  /**
   * Toggle report download button visibilitys
   * @returns
   */
  toggleReportDownloadButton(hidden) {
    const reportsViewer = document.getElementById("reportsViewer");
    const downloadButton = document.getElementById("downloadReportButton");

    if (!reportsViewer || !downloadButton) return;

    // Vérifie si la div est vide
    if (hidden) {
      downloadButton.style.display = "none"; // Cache complètement le bouton
    } else {
      downloadButton.style.display = "flex"; // Affiche le bouton
    }
  }
}

var reportClass;
document.addEventListener("DOMContentLoaded", () => {
  reportClass = new Report();
});
