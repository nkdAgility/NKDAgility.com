// Appearance switcher functionality (enhanced theme switcher)
document.addEventListener("DOMContentLoaded", function () {
  console.log("Appearance switcher loaded");

  // Initialize all appearance settings
  initializeTheme();
  initializeTextFont();

  // Wait for dropdown elements to be available and then update UI
  waitForDropdownElements();

  // Handle theme option clicks
  const themeOptions = document.querySelectorAll(".theme-option");
  if (themeOptions.length > 0) {
    console.log("Theme options found, adding event listeners");
    themeOptions.forEach((option) => {
      option.addEventListener("click", (e) => {
        const selectedTheme = e.currentTarget.getAttribute("data-theme");
        console.log(`Theme option clicked: ${selectedTheme}`);

        // Store the selected theme preference
        localStorage.setItem("theme", selectedTheme);

        // Apply theme based on selection
        if (selectedTheme === "system") {
          const systemTheme = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
          setTheme(systemTheme);
        } else {
          setTheme(selectedTheme);
        }

        // Update UI to reflect selection
        updateThemeSelectionUI(selectedTheme);
      });
    });
  }

  // Handle text font option clicks
  const textFontOptions = document.querySelectorAll(".text-font-option");
  if (textFontOptions.length > 0) {
    console.log("Text font options found, adding event listeners");
    textFontOptions.forEach((option) => {
      option.addEventListener("click", (e) => {
        const selectedFont = e.currentTarget.getAttribute("data-text-font");
        console.log(`Text font option clicked: ${selectedFont}`);

        // Store and apply the selected text font
        localStorage.setItem("textFont", selectedFont);
        setTextFont(selectedFont);
        updateTextFontSelectionUI(selectedFont);
      });
    });
  }

  // Listen for system preference changes
  window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", (e) => {
    const currentThemePreference = localStorage.getItem("theme");
    if (currentThemePreference === "system") {
      // Auto-switch if system theme is selected
      setTheme(e.matches ? "dark" : "light");
    }
  });
});

// Wait for dropdown elements to be available before updating UI
function waitForDropdownElements() {
  const maxAttempts = 20; // Try for up to 2 seconds
  let attempts = 0;

  function checkForElements() {
    attempts++;
    const themeChecks = document.querySelectorAll(".theme-check");
    const fontChecks = document.querySelectorAll(".text-font-check");

    console.log(`[ThemeSwitcher] Attempt ${attempts}: Found ${themeChecks.length} theme checks, ${fontChecks.length} font checks`);

    if (themeChecks.length > 0) {
      // Elements are available, update UI
      const savedTheme = localStorage.getItem("theme") || "system";
      const savedFont = localStorage.getItem("textFont") || "default";

      console.log(`[ThemeSwitcher] Elements found, updating UI - theme: ${savedTheme}, font: ${savedFont}`);
      updateThemeSelectionUI(savedTheme);
      updateTextFontSelectionUI(savedFont);
      return; // Success, stop trying
    }

    if (attempts < maxAttempts) {
      setTimeout(checkForElements, 100);
    } else {
      console.warn(`[ThemeSwitcher] Failed to find dropdown elements after ${maxAttempts} attempts`);
    }
  }

  // Start checking immediately and then repeatedly
  checkForElements();
}

// Initialize theme settings
function initializeTheme() {
  const savedTheme = localStorage.getItem("theme");
  const systemPrefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;

  let themeToSet;
  let themePreference = savedTheme || "system";

  if (themePreference === "system") {
    themeToSet = systemPrefersDark ? "dark" : "light";
    localStorage.setItem("theme", "system");
  } else {
    themeToSet = themePreference;
  }

  setTheme(themeToSet);

  // Ensure images are properly swapped on initial load
  setTimeout(() => {
    console.log("Running delayed image swap to ensure all images are loaded");
    swapThemeImages(themeToSet);
  }, 500);
}

// Initialize text font settings
function initializeTextFont() {
  const savedTextFont = localStorage.getItem("textFont") || "default";
  setTextFont(savedTextFont);
}

// Set the theme by updating the data-theme attribute
function setTheme(theme) {
  console.log(`Setting theme to: ${theme}`);
  document.documentElement.setAttribute("data-theme", theme);
  document.body.classList.remove("theme-light", "theme-dark");
  document.body.classList.add(`theme-${theme}`);
  updateThemeIcon(theme);

  // Handle theme-aware images
  swapThemeImages(theme);
}

// Set text font by updating CSS classes
function setTextFont(font) {
  console.log(`Setting text font to: ${font}`);
  document.body.classList.remove("text-font-default", "text-font-dyslexic", "text-font-lexend", "text-font-atkinson");
  document.body.classList.add(`text-font-${font}`);
}

// Update the theme selection UI
function updateThemeSelectionUI(preference) {
  console.log(`Updating theme selection UI for preference: ${preference}`);

  // First, hide all checkmarks
  const allChecks = document.querySelectorAll(".theme-check");
  console.log(`Found ${allChecks.length} theme check elements`);
  allChecks.forEach((check) => {
    check.classList.add("d-none");
  });

  // Show the correct checkmark
  const selectedCheck = document.querySelector(`.theme-${preference}-check`);
  console.log(`Looking for .theme-${preference}-check, found:`, !!selectedCheck);
  if (selectedCheck) {
    selectedCheck.classList.remove("d-none");
    console.log(`Checkmark shown for theme: ${preference}`);
  } else {
    console.warn(`Checkmark element not found for theme: ${preference}`);
    // List available checkmark elements for debugging
    allChecks.forEach((check) => {
      console.log(`Available check element classes: ${check.className}`);
    });
  }

  updateThemeIcon(document.documentElement.getAttribute("data-theme") || "light");
}

// Update the text font selection UI
function updateTextFontSelectionUI(font) {
  console.log(`Updating text font selection UI for font: ${font}`);
  document.querySelectorAll(".text-font-check").forEach((check) => {
    check.classList.add("d-none");
  });

  const selectedCheck = document.querySelector(`.text-font-${font}-check`);
  if (selectedCheck) {
    selectedCheck.classList.remove("d-none");
  }
}

// Update the theme toggle icon based on current theme
function updateThemeIcon(theme) {
  const themeToggleIcon = document.getElementById("theme-toggle-icon");
  if (themeToggleIcon) {
    themeToggleIcon.classList.remove("fa-sun", "fa-moon", "fa-display");

    const themePref = localStorage.getItem("theme");

    if (themePref === "system") {
      themeToggleIcon.classList.add("fa-display");
    } else {
      themeToggleIcon.classList.add(theme === "dark" ? "fa-moon" : "fa-sun");
    }
  }
}

// Swap images based on theme (existing functionality)
function swapThemeImages(theme) {
  console.log(`Swapping images for ${theme} theme`);

  const themeImages = document.querySelectorAll("[data-theme-src-light], [data-theme-src-dark]");
  console.log(`Found ${themeImages.length} theme-aware images`);

  themeImages.forEach((img, index) => {
    const lightSrc = img.getAttribute("data-theme-src-light");
    const darkSrc = img.getAttribute("data-theme-src-dark");

    console.log(`Image ${index + 1}: light src = ${lightSrc}, dark src = ${darkSrc}`);

    if (lightSrc && darkSrc) {
      const previousSrc = img.src;
      if (theme === "dark" && darkSrc) {
        img.src = darkSrc;
        console.log(`Changed image ${index + 1} from ${previousSrc} to ${darkSrc}`);
      } else if (theme === "light" && lightSrc) {
        img.src = lightSrc;
        console.log(`Changed image ${index + 1} from ${previousSrc} to ${lightSrc}`);
      }
    }
  });
}
