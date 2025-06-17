(function () {
  try {
    // Set theme
    var theme = localStorage.getItem("theme");
    if (!theme || theme === "system") {
      // Use system preference if no theme or 'system' is set
      theme = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
    }
    document.documentElement.setAttribute("data-theme", theme);
    
    // Set text font
    var textFont = localStorage.getItem("textFont") || "default";
    document.body.classList.add("text-font-" + textFont);
  } catch (e) {}
})();