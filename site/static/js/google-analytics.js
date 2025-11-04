document.addEventListener("DOMContentLoaded", function () {
  // Enhanced dynamic GA event tracking
  document.querySelectorAll("[data-ga-event]").forEach(function (element) {
    element.addEventListener("click", function (e) {
      if (typeof gtag !== "undefined") {
        // Build event parameters dynamically from data attributes
        const eventParams = {};

        // Standard parameters
        if (this.dataset.gaCategory) eventParams.event_category = this.dataset.gaCategory;
        if (this.dataset.gaLabel) eventParams.event_label = this.dataset.gaLabel;
        if (this.dataset.gaValue) eventParams.value = parseInt(this.dataset.gaValue);

        // Allow any custom parameters with data-ga-param-* pattern
        Object.keys(this.dataset).forEach((key) => {
          if (key.startsWith("gaParam")) {
            const paramName = key
              .replace("gaParam", "")
              .toLowerCase()
              .replace(/([A-Z])/g, "_$1");
            eventParams[paramName] = this.dataset[key];
          }
        });

        // Send the event
        gtag("event", this.dataset.gaEvent, eventParams);

        // Optional: Log for debugging in development
        if (window.location.hostname === "localhost") {
          console.log("GA Event:", this.dataset.gaEvent, eventParams);
        }
      }
    });
  });

  // Also handle dynamically added elements
  document.addEventListener("click", function (e) {
    const element = e.target.closest("[data-ga-event]");
    if (element && typeof gtag !== "undefined") {
      // Prevent duplicate events from the above listener
      if (element.hasAttribute("data-ga-processed")) return;

      const eventParams = {};
      if (element.dataset.gaCategory) eventParams.event_category = element.dataset.gaCategory;
      if (element.dataset.gaLabel) eventParams.event_label = element.dataset.gaLabel;
      if (element.dataset.gaValue) eventParams.value = parseInt(element.dataset.gaValue);

      Object.keys(element.dataset).forEach((key) => {
        if (key.startsWith("gaParam")) {
          const paramName = key
            .replace("gaParam", "")
            .toLowerCase()
            .replace(/([A-Z])/g, "_$1");
          eventParams[paramName] = element.dataset[key];
        }
      });

      gtag("event", element.dataset.gaEvent, eventParams);
    }
  });
});
