document.addEventListener("DOMContentLoaded", function () {
  // Enhanced dynamic GA event tracking using GTM dataLayer
  document.querySelectorAll("[data-ga-event]").forEach(function (element) {
    element.addEventListener("click", function (e) {
      // Check if dataLayer exists (GTM)
      if (typeof window.dataLayer !== "undefined") {
        // Build event parameters dynamically from data attributes
        const eventData = {
          event: this.dataset.gaEvent,
        };

        // Standard parameters
        if (this.dataset.gaCategory) eventData.event_category = this.dataset.gaCategory;
        if (this.dataset.gaLabel) eventData.event_label = this.dataset.gaLabel;
        if (this.dataset.gaValue) eventData.value = parseInt(this.dataset.gaValue);

        // Allow any custom parameters with data-ga-param-* pattern
        Object.keys(this.dataset).forEach((key) => {
          if (key.startsWith("gaParam")) {
            const paramName = key
              .replace("gaParam", "")
              .toLowerCase()
              .replace(/([A-Z])/g, "_$1");
            eventData[paramName] = this.dataset[key];
          }
        });

        // Send the event via dataLayer
        window.dataLayer.push(eventData);

        // Log for debugging in development
        if (window.location.hostname === "localhost") {
          console.log("GTM Event pushed to dataLayer:", eventData);
        }
      }
      // Fallback to gtag if available (for direct GA4 implementations)
      else if (typeof gtag !== "undefined") {
        const eventParams = {};
        if (this.dataset.gaCategory) eventParams.event_category = this.dataset.gaCategory;
        if (this.dataset.gaLabel) eventParams.event_label = this.dataset.gaLabel;
        if (this.dataset.gaValue) eventParams.value = parseInt(this.dataset.gaValue);

        Object.keys(this.dataset).forEach((key) => {
          if (key.startsWith("gaParam")) {
            const paramName = key
              .replace("gaParam", "")
              .toLowerCase()
              .replace(/([A-Z])/g, "_$1");
            eventParams[paramName] = this.dataset[key];
          }
        });

        gtag("event", this.dataset.gaEvent, eventParams);

        if (window.location.hostname === "localhost") {
          console.log("GA Event:", this.dataset.gaEvent, eventParams);
        }
      }
    });
  });

  // Also handle dynamically added elements
  document.addEventListener("click", function (e) {
    const element = e.target.closest("[data-ga-event]");
    if (element) {
      // Prevent duplicate events from the above listener
      if (element.hasAttribute("data-ga-processed")) return;

      if (typeof window.dataLayer !== "undefined") {
        const eventData = {
          event: element.dataset.gaEvent,
        };

        if (element.dataset.gaCategory) eventData.event_category = element.dataset.gaCategory;
        if (element.dataset.gaLabel) eventData.event_label = element.dataset.gaLabel;
        if (element.dataset.gaValue) eventData.value = parseInt(element.dataset.gaValue);

        Object.keys(element.dataset).forEach((key) => {
          if (key.startsWith("gaParam")) {
            const paramName = key
              .replace("gaParam", "")
              .toLowerCase()
              .replace(/([A-Z])/g, "_$1");
            eventData[paramName] = element.dataset[key];
          }
        });

        window.dataLayer.push(eventData);

        if (window.location.hostname === "localhost") {
          console.log("GTM Event pushed to dataLayer (dynamic):", eventData);
        }
      } else if (typeof gtag !== "undefined") {
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
    }
  });
});
