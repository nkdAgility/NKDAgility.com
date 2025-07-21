/**
 * Adds "latest" or "recent" badges to resource cards based on publication dates
 * "latest" = most recent article
 * "recent" = published within the last 4 weeks
 */
(function () {
  "use strict";

  function addResourceBadges() {
    // Get all card-top-bits elements
    const cardTopBits = document.querySelectorAll(".card-top-bits");

    if (cardTopBits.length === 0) {
      return;
    }

    const now = new Date();
    const fourWeeksAgo = new Date(now.getTime() - 4 * 7 * 24 * 60 * 60 * 1000); // 4 weeks in milliseconds

    let latestDate = null;
    let latestElements = [];
    const recentElements = [];

    // First pass: collect all dates and find the latest
    cardTopBits.forEach((cardTopBit) => {
      const timeElement = cardTopBit.querySelector("time[datetime]");
      if (!timeElement) {
        return;
      }

      const dateString = timeElement.getAttribute("datetime");
      const articleDate = new Date(dateString);

      // Skip invalid dates or future dates
      if (isNaN(articleDate.getTime()) || articleDate > now) {
        return;
      }

      // Track the latest date and elements (only for published articles)
      if (!latestDate || articleDate > latestDate) {
        latestDate = articleDate;
        latestElements = [cardTopBit];
      } else if (articleDate.getTime() === latestDate.getTime()) {
        latestElements.push(cardTopBit);
      }

      // Check if it's recent (within 4 weeks)
      if (articleDate >= fourWeeksAgo) {
        recentElements.push(cardTopBit);
      }
    });

    // Second pass: add badges
    // Add "latest" badge to the most recent article(s)
    latestElements.forEach((element) => {
      addBadge(element, "latest", "bg-success text-white");
    });

    // Add "recent" badge to articles within 4 weeks (excluding latest)
    recentElements.forEach((element) => {
      // Don't add "recent" if it already has "latest"
      if (!latestElements.includes(element)) {
        addBadge(element, "recent", "bg-primary text-white");
      }
    });
  }

  function addBadge(cardTopBit, badgeText, badgeClasses) {
    // Check if badge already exists
    if (cardTopBit.querySelector(".resource-badge")) {
      return;
    }

    const badge = document.createElement("span");
    badge.className = `resource-badge badge ${badgeClasses} ms-2 fs-7`;
    badge.textContent = badgeText;
    badge.setAttribute("aria-label", `${badgeText} article`);

    // Insert the badge at the end of the card-top-bits
    const smallElement = cardTopBit.querySelector("small");
    if (smallElement) {
      smallElement.appendChild(badge);
    }
  }

  // Run when DOM is loaded
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", addResourceBadges);
  } else {
    addResourceBadges();
  }

  // Also run on page changes (for single-page applications or dynamic content)
  if (typeof window.addEventListener === "function") {
    window.addEventListener("load", addResourceBadges);

    // Listen for potential page updates (if using AJAX/fetch)
    document.addEventListener("resourcesUpdated", addResourceBadges);
  }
})();
