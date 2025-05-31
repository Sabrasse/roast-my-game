// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// Import all required modules
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "turbo_scroll"

// Add a DOMContentLoaded listener to check if the page is properly loaded
document.addEventListener("DOMContentLoaded", () => {
  // Check if dynamic elements are present
  const latestGamesSection = document.querySelector(".latest-games-section")
  const counterElements = document.querySelectorAll("[data-counter]")
  
  if (!latestGamesSection) {
    console.warn("Latest games section not found")
  }
  if (counterElements.length === 0) {
    console.warn("No counter elements found")
  }
});
