// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
console.log("Application.js loading...");
import "@hotwired/turbo-rails"
console.log("Turbo Rails loaded");
import "controllers"
console.log("Controllers loaded");
import "@popperjs/core"
console.log("Popper loaded");
import "bootstrap"
console.log("Bootstrap loaded");
import "./turbo_scroll"
console.log("Turbo scroll loaded");

// Add a DOMContentLoaded listener to check if the page is properly loaded
document.addEventListener("DOMContentLoaded", () => {
  console.log("DOM fully loaded");
  // Check if dynamic elements are present
  console.log("Latest games section:", document.querySelector(".latest-games-section"));
  console.log("Counter elements:", document.querySelectorAll("[data-counter]"));
});
