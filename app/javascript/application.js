// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
console.log("Application.js loading...");

// Import all required modules
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "turbo_scroll"

// Log successful imports
console.log("All modules imported successfully");

// Add a DOMContentLoaded listener to check if the page is properly loaded
document.addEventListener("DOMContentLoaded", () => {
  console.log("DOM fully loaded");
  // Check if dynamic elements are present
  console.log("Latest games section:", document.querySelector(".latest-games-section"));
  console.log("Counter elements:", document.querySelectorAll("[data-counter]"));
});
