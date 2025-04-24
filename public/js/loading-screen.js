document.addEventListener("DOMContentLoaded", function () {
  const loadingScreen = document.getElementById("loadingScreen");

  // Cacher l'écran de chargement une fois la page complètement chargée
  window.onload = function() {
    loadingScreen.style.display = "none"; // Masque l'écran de chargement
  };
});