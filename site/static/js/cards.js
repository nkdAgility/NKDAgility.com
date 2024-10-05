document.querySelectorAll(".show-more").forEach(function (button) {
  button.addEventListener("click", function () {
    var card = this.closest(".card");

    if (card.classList.contains("expanded")) {
      card.classList.remove("expanded");
      this.textContent = "details...";
    } else {
      card.classList.add("expanded");
      this.textContent = "hide details...";
    }
  });
});
