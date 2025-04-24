class Editor {
  constructor() {
    this.modal = document.getElementById("editorModal");
    this.quill = new Quill("#reportsEditor", { theme: "snow" });
  }

  toggleModal() {
    this.fillEditorFromViewer();
    this.toggleModalVisibility();
  }

  fillEditorFromViewer() {
    const reportsViewer = document.getElementById("reportsViewer");
    if (!reportsViewer) return;

    const clonedViewer = reportsViewer.cloneNode(true);

    clonedViewer.querySelectorAll("button").forEach((btn) => btn.remove());

    const content = clonedViewer.innerHTML;

    if (this.quill) {
      this.quill.clipboard.dangerouslyPasteHTML(content);
    }
  }

  toggleModalVisibility() {
    this.modal.hasAttribute("open")
      ? this.modal.close()
      : this.modal.showModal();
  }

  // Téléchargement en DOCX
  async downloadAsWord() {
    const content = this.quill.getText(); // Récupère le texte brut de Quill
    const id = document.getElementById("dataId").value;
    const lastname = document.getElementById("dataLastName").value;
    const firstname = document.getElementById("dataFirstName").value;
    const dn = document.getElementById("dataDn").value;

    if (!id) return;

    // Fonction pour afficher une valeur par défaut si vide
    const displayValue = (value) => value || "Non renseigné";

    // Créer un tableau pour l'en-tête
    const headerTable = new docx.Table({
      rows: [
        new docx.TableRow({
          children: [
            new docx.TableCell({
              children: [new docx.Paragraph({ text: "Dossier", bold: true })],
              width: { size: 3000, type: docx.WidthType.DXA }, // Largeur fixe pour la première colonne
            }),
            new docx.TableCell({
              children: [new docx.Paragraph({ text: displayValue(id) })],
              width: { size: 3000, type: docx.WidthType.DXA }, // Largeur fixe pour la deuxième colonne
            }),
          ],
        }),
        new docx.TableRow({
          children: [
            new docx.TableCell({
              children: [new docx.Paragraph({ text: "Nom", bold: true })],
            }),
            new docx.TableCell({
              children: [new docx.Paragraph({ text: displayValue(lastname) })],
            }),
          ],
        }),
        new docx.TableRow({
          children: [
            new docx.TableCell({
              children: [new docx.Paragraph({ text: "Prénom", bold: true })],
            }),
            new docx.TableCell({
              children: [new docx.Paragraph({ text: displayValue(firstname) })],
            }),
          ],
        }),
        new docx.TableRow({
          children: [
            new docx.TableCell({
              children: [new docx.Paragraph({ text: "Numéro DN", bold: true })],
            }),
            new docx.TableCell({
              children: [new docx.Paragraph({ text: displayValue(dn) })],
            }),
          ],
        }),
      ],
      width: { size: 100, type: docx.WidthType.PERCENTAGE }, // Largeur du tableau à 100% de la page
      columnWidths: [2000, 8000], // Largeur des colonnes en DXA (1 DXA = 1/20 de point)
      margins: { top: 100, bottom: 100, left: 100, right: 100 }, // Marges du tableau
    });

    // Créer le document Word
    const doc = new docx.Document({
      sections: [
        {
          properties: {},
          children: [
            // Titre de l'en-tête
            new docx.Paragraph({
              text: "Informations de la personne",
              heading: docx.HeadingLevel.HEADING_2,
              alignment: docx.AlignmentType.CENTER,
              spacing: { after: 200 },
            }),

            // Tableau d'en-tête
            headerTable,

            // Espace entre l'en-tête et le contenu
            new docx.Paragraph({
              text: "",
              spacing: { after: 400 },
            }),

            // Contenu du document
            new docx.Paragraph({
              text: content,
              spacing: { after: 200 },
            }),
          ],
        },
      ],
    });

    // Générer le fichier DOCX et le télécharger
    docx.Packer.toBlob(doc).then((blob) => {
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = `${id}-${lastname}-${firstname}-rapport.docx`;
      a.click();
      URL.revokeObjectURL(url);
    });
  }

  // Téléchargement en PDF
  downloadAsPDF() {
    const content = this.quill.root.innerHTML;
    const id = document.getElementById("dataId").value;
    const lastname = document.getElementById("dataLastName").value;
    const firstname = document.getElementById("dataFirstName").value;
    const dn = document.getElementById("dataDn").value;

    if (!id) return;

    // Créer un nouvel élément div pour contenir l'en-tête et le contenu
    const pdfContent = document.createElement("div");

    // Ajouter l'en-tête avec les informations de la personne dans un tableau
    const header = `
    <div style="margin-bottom: 20px;">
      <h2 style="text-align: center; font-size: 18px; margin-bottom: 10px;">Informations de la personne</h2>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <tr>
          <th style="border: 1px solid #000; padding: 8px; background-color: #f2f2f2; text-align: left;">Dossier</th>
          <td style="border: 1px solid #000; padding: 8px;">${id}</td>
        </tr>
        <tr>
          <th style="border: 1px solid #000; padding: 8px; background-color: #f2f2f2; text-align: left;">Nom</th>
          <td style="border: 1px solid #000; padding: 8px;">${lastname}</td>
        </tr>
        <tr>
          <th style="border: 1px solid #000; padding: 8px; background-color: #f2f2f2; text-align: left;">Prénom</th>
          <td style="border: 1px solid #000; padding: 8px;">${firstname}</td>
        </tr>
        <tr>
          <th style="border: 1px solid #000; padding: 8px; background-color: #f2f2f2; text-align: left;">Numéro DN</th>
          <td style="border: 1px solid #000; padding: 8px;">${dn}</td>
        </tr>
      </table>
    </div>
  `;

    // Ajouter l'en-tête et le contenu original au nouvel élément
    pdfContent.innerHTML = header + content;

    const cleanLastName = lastname.replace(/[^a-zA-Z0-9-_]/g, "-"); // Remplace les caractères spéciaux par "-"
    const cleanFirstName = firstname.replace(/[^a-zA-Z0-9-_]/g, "-"); // Remplace les caractères spéciaux par "-"
    const filename = `${id}-${cleanLastName}-${cleanFirstName}-rapport.pdf`;

    // Utilisation de html2pdf avec des marges classiques
    html2pdf()
      .from(pdfContent)
      .set({
        margin: [10, 10, 10, 10], // Marges de 10 mm (1 cm) sur tous les côtés
        filename: filename,
        html2canvas: { scale: 2 },
        jsPDF: {
          orientation: "portrait",
          unit: "mm", // Unités en millimètres
          format: "a4", // Format A4
        },
      })
      .save();
  }
}

// Initialisation
var editorClass;
document.addEventListener("DOMContentLoaded", () => {
  editorClass = new Editor();
});
