document.addEventListener("click", (event) => {
  const mobileMenu = document.getElementById("mobile-menu");
  const menuButton = document.getElementById("menu-toggle");

  if (menuButton.contains(event.target)) {
    mobileMenu.classList.toggle("hidden");
  } else if (!mobileMenu.contains(event.target)) {
    mobileMenu.classList.add("hidden");
  }
});