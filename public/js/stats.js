class ChartManager {
  constructor() {
    this.chartInstances = {};
  }

  async fetchData(url) {
    try {
      const response = await fetch(url, {
        method: "GET",
        headers: { "Content-Type": "application/json" },
      });

      const result = await response.json();

      if (!result.success) throw new Error(result.message || "Unknown error");

      return {
        success: true,
        message: result.message || "Data retrieved successfully",
        data: result.data,
      };
    } catch (error) {
      console.error("Error fetching data:", error);
      return {
        success: false,
        message: error.message || "Failed to fetch data",
        data: [],
      };
    }
  }

  async genderDistributionChart() {
    try {
      const response = await this.fetchData(
        "/api/statistiques/repartition-genre"
      );

      if (!response.success || !Array.isArray(response.data)) {
        console.error("Invalid data received");
        return;
      }

      const labels = response.data.map((item) => item.genre);
      const values = response.data.map((item) => item.quantite);

      this.createChart("genderDistributionChart", {
        type: "pie",
        data: {
          labels: labels,
          datasets: [
            {
              data: values,
              backgroundColor: ["#ef4444", "#3b82f6", "#fa33ff"],
            },
          ],
        },
        options: {
          responsive: true,
          plugins: {
            tooltip: {
              enabled: true,
              callbacks: {
                label: (context) => {
                  const label = context.label || "";
                  const value = context.raw || 0;
                  const total = context.dataset.data.reduce(
                    (acc, val) => acc + val,
                    0
                  );
                  const percentage = ((value / total) * 100).toFixed(2) + "%";
                  return `${label}: ${value} (${percentage})`;
                },
              },
            },
            legend: {
              position: "top",
            },
            datalabels: {
              display: true,
              formatter: (value, ctx) => {
                const total = ctx.dataset.data.reduce(
                  (acc, val) => acc + val,
                  0
                );
                const percentage = ((value / total) * 100).toFixed(0) + "%";
                return percentage + " (" + value + ")";
              },
              color: "#fff",
              font: {
                weight: "bold",
                size: 16,
              },
              anchor: "center",
              align: "center",
            },
          },
        },
      });
    } catch (error) {
      console.error("Erreur lors de la récupération des données :", error);
    }
  }

  async sixMonthsProgressionChart() {
    try {
      const response = await this.fetchData(
        "/api/statistiques/progression-6-mois"
      );

      if (!response.success || !Array.isArray(response.data)) {
        console.error("Invalid data received");
        return;
      }

      response.data.reverse();

      const labels = response.data.map((item) => item.mois);
      const data = response.data.map((item) => item.nombre);

      this.createChart("sixMonthsProgressionChart", {
        type: "line",
        data: {
          labels: labels,
          datasets: [
            {
              label: "Nombre de dossiers créés",
              data: data,
              fill: false,
              borderColor: "#3b82f6",
              tension: 0.1,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
        },
      });
    } catch (error) {
      console.error("Erreur lors de la récupération des données :", error);
    }
  }

  async typologyDistributionChart() {
    try {
      const response = await this.fetchData(
        "/api/statistiques/repartition-typologie"
      );

      if (!response.success || !Array.isArray(response.data)) {
        console.error("Invalid data received");
        return;
      }

      const labels = response.data.map((item) => item.typologie);
      const values = response.data.map((item) => item.quantite);

      this.createChart("typologyDistributionChart", {
        type: "doughnut",
        data: {
          labels: labels,
          datasets: [
            {
              data: values,
              backgroundColor: [
                "#FF5733",
                "#33A1FF",
                "#FFD700",
                "#8A2BE2",
                "#228B22",
                "#DC143C",
                "#FF8C00",
                "#808080",
                "#424242",
              ],
            },
          ],
        },
        options: {
          responsive: true,
          plugins: {
            tooltip: {
              enabled: true,
              callbacks: {
                label: (context) => {
                  const label = context.label || "";
                  const value = context.raw || 0;
                  const total = context.dataset.data.reduce(
                    (acc, val) => acc + val,
                    0
                  );
                  const percentage = ((value / total) * 100).toFixed(2) + "%";
                  return `${label}: ${value} (${percentage})`;
                },
              },
            },
            legend: {
              position: "top",
            },
            datalabels: {
              display: true,
              formatter: (value, ctx) => {
                const total = ctx.dataset.data.reduce(
                  (acc, val) => acc + val,
                  0
                );
                const percentage = ((value / total) * 100).toFixed(0) + "%" + ' (' + value + ')';
                return percentage;
              },
              color: "#fff",
              font: {
                weight: "bold",
                size: 16,
              },
              anchor: "center",
              align: "center",
            },
          },
        },
      });
    } catch (error) {
      console.error("Erreur lors de la récupération des données :", error);
    }
  }

  async populationDistributionChart() {
    try {
      const response = await this.fetchData(
        "/api/statistiques/repartition-population"
      );

      if (!response.success || !Array.isArray(response.data)) {
        console.error("Invalid data received");
        return;
      }

      const data = response.data;

      const filterDataByType = (type) => {
        let filteredData = data.filter((item) => item.dernier_comptage > 0); // Ignore les zones avec un comptage de 0
        if (type !== "all") {
          filteredData = filteredData.filter((item) => item.type === type); // Filtre par type si nécessaire
        }
        return filteredData;
      };

      const updateChart = (type) => {
        const filteredData = filterDataByType(type);

        // Trier les données par ordre croissant de dernier_comptage
        const sortedData = filteredData.sort(
          (a, b) => a.dernier_comptage - b.dernier_comptage
        );

        const labels = sortedData.map((item) => item.lib);
        const values = sortedData.map((item) => item.dernier_comptage);

        if (this.chartInstances.populationDistributionChart) {
          this.chartInstances.populationDistributionChart.destroy();
        }

        this.chartInstances.populationDistributionChart = this.createChart(
          "populationDistributionChart",
          {
            type: "bar",
            data: {
              labels: labels,
              datasets: [
                {
                  label: "",
                  data: values,
                  backgroundColor: [
                    "#FF5733",
                    "#33A1FF",
                    "#FFD700",
                    "#8A2BE2",
                    "#228B22",
                    "#DC143C",
                    "#FF8C00",
                    "#808080",
                  ],
                  borderColor: "#000",
                  borderWidth: 1,
                },
              ],
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              plugins: {
                legend: {
                  display: true,
                  position: "top",
                },
                tooltip: {
                  enabled: true,
                },
                datalabels: {
                  display: true,
                  anchor: "end",
                  align: "top",
                  formatter: (value) => value,
                  color: "#000",
                  font: {
                    weight: "bold",
                    size: 12,
                  },
                },
              },
              scales: {
                x: {
                  title: {
                    display: true,
                    text: "Zones",
                  },
                },
                y: {
                  title: {
                    display: true,
                    text: "Population",
                  },
                  beginAtZero: true,
                },
              },
            },
          }
        );
      };

      document
        .getElementById("zoneType")
        .addEventListener("change", (event) => {
          const selectedType = event.target.value;
          updateChart(selectedType);
        });

      updateChart("all");
    } catch (error) {
      console.error("Erreur lors de la récupération des données :", error);
    }
  }

  createChart(chartId, config) {
    const ctx = document.getElementById(chartId);
    if (!ctx) {
      console.error(`Element with id ${chartId} not found`);
      return null;
    }
    return new Chart(ctx, config);
  }

  init() {
    Chart.register(ChartDataLabels);
    this.genderDistributionChart();
    this.sixMonthsProgressionChart();
    this.typologyDistributionChart();
    this.populationDistributionChart();
  }
}

// Usage

var chartManager;
document.addEventListener("DOMContentLoaded", () => {
  chartManager = new ChartManager();
  chartManager.init();
});
