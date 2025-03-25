document.addEventListener("turbo:load", () => {
  // Scroll to top on every Turbo navigation
  window.scrollTo({ top: 0, behavior: 'instant' });
});

document.addEventListener("turbo:before-cache", () => {
  // Ensure scroll position is reset before caching
  window.scrollTo({ top: 0, behavior: 'instant' });
}); 