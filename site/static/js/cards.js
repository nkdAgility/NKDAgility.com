document.addEventListener("DOMContentLoaded", function () {
  console.log("DOM fully loaded and parsed.");

  document.querySelectorAll(".card").forEach(function (card, index) {
    console.log(`Processing card ${index + 1}`);

    var textContainer = card.querySelector(".card-text-expander");
    if (!textContainer) {
      console.warn(`Card ${index + 1}: No text container found.`);
      return; // Skip this card if no text container
    }

    console.log(`Card ${index + 1}: Text container found.`);
    var paragraphs = textContainer.querySelectorAll("p");
    console.log(`Card ${index + 1}: Found ${paragraphs.length} paragraph(s).`);

    // Find the "More" button
    var showMoreButton = card.querySelector(".show-more");
    if (!showMoreButton) {
      console.warn(`Card ${index + 1}: No "More" button found.`);
    } else {
      console.log(`Card ${index + 1}: "More" button found.`);
      
      if (paragraphs.length <= 1) {
        showMoreButton.style.display = "none"; // Hide the button if there's 1 or fewer paragraphs
        console.log(`Card ${index + 1}: Hiding "More" button.`);
      } else {
        showMoreButton.style.display = "inline-block"; // Ensure button is visible when needed
        console.log(`Card ${index + 1}: Displaying "More" button.`);
      }

      // Expand/collapse logic if the button exists
      showMoreButton.addEventListener("click", function () {
        if (card.classList.contains("expanded")) {
          card.classList.remove("expanded");
          this.textContent = "details...";
          console.log(`Card ${index + 1}: Collapsed.`);
        } else {
          card.classList.add("expanded");
          this.textContent = "hide details...";
          console.log(`Card ${index + 1}: Expanded.`);
        }
      });
    }
  });
});
