document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".card").forEach(function (card) {
    var textContainer = card.querySelector(".card-text-expander");
    if (textContainer) {
      var paragraphs = textContainer ? textContainer.querySelectorAll("p") : [];

      // Find the "More" button
      var showMoreButton = card.querySelector(".show-more");

      // Check if showMoreButton exists
      if (showMoreButton && paragraphs.length <= 1) {
        showMoreButton.style.display = "none"; // Hide the button if there's 1 or fewer paragraphs
      } else if (showMoreButton) {
        showMoreButton.style.display = "inline-block"; // Ensure button is visible when needed
      }

      // Expand/collapse logic if the button exists
      if (showMoreButton) {
        showMoreButton.addEventListener("click", function () {
          if (card.classList.contains("expanded")) {
            card.classList.remove("expanded");
            this.textContent = "details...";
          } else {
            card.classList.add("expanded");
            this.textContent = "hide details...";
          }
        });
      }
    }
  });
});
