function notifyPopup(type, message) {
  const notification = document.getElementById("notificationPopup");
  const notificationMessage = document.getElementById("notificationMessage");

  // Clean background color
  notification.style.backgroundColor = "";

  // Apply background color depending on type
  if (type === "error") {
    notification.style.backgroundColor = "#fee2e2"; // Rouge clair (bg-red-100)
  } else if (type === "success") {
    notification.style.backgroundColor = "#d1fae5"; // Vert clair (bg-green-100)
  } else if (type === "info") {
    notification.style.backgroundColor = "#dbeafe"; // Bleu clair (bg-blue-100)
  }

  // Update message
  notificationMessage.textContent = message;

  // Show notification
  notification.classList.remove("hidden");

  // Hide notification after 3 seconds
  setTimeout(() => {
    notification.classList.add("hidden");
  }, 3000);
}