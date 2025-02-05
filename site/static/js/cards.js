console.log("cards.js is running");

document.querySelectorAll(".card").forEach(function (card, index) {
  console.log(`Processing card ${index + 1}`);

  var textContainer = card.querySelector(".card-text-expander");
  if (!textContainer) {
    console.warn(`Card ${index + 1}: No text container found.`);
    return; // Skip this card
  }

  console.log(`Card ${index + 1}: Found text container.`);
  var paragraphs = textContainer.querySelectorAll("p");
  console.log(`Card ${index + 1}: Found ${paragraphs.length} paragraph(s).`);

  var showMoreButton = card.querySelector(".show-more");
  if (!showMoreButton) {
    console.warn(`Card ${index + 1}: No "More" button found.`);
    return; // Skip further logic if no button
  }

  console.log(`Card ${index + 1}: Found "More" button.`);
  if (paragraphs.length <= 1) {
    showMoreButton.style.display = "none";
    console.log(`Card ${index + 1}: Hiding "More" button.`);
  } else {
    showMoreButton.style.display = "inline-block";
    console.log(`Card ${index + 1}: Displaying "More" button.`);
  }

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
});
