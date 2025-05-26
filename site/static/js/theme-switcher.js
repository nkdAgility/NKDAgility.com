// Theme switcher functionality
document.addEventListener("DOMContentLoaded", function() {
  console.log("Theme switcher loaded");
  // Check for saved theme preference or use system preference
  const savedTheme = localStorage.getItem('theme');
  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  
  // Define theme handling
  let themeToSet;
  let themePreference = savedTheme || 'system';
  
  if (themePreference === 'system') {
    // If theme is set to system or no preference is saved
    themeToSet = systemPrefersDark ? 'dark' : 'light';
    // Ensure system preference is stored
    localStorage.setItem('theme', 'system');
  } else {
    // Use saved theme preference
    themeToSet = themePreference;
  }
  
  // Apply the theme
  setTheme(themeToSet);
  
  // Update theme selection indication based on saved preference
  updateThemeSelectionUI(themePreference);
  
  // Handle theme option clicks in dropdown
  const themeOptions = document.querySelectorAll('.theme-option');
  if (themeOptions.length > 0) {
    console.log("Theme options found, adding event listeners");
    themeOptions.forEach(option => {
      option.addEventListener('click', (e) => {
        const selectedTheme = e.currentTarget.getAttribute('data-theme');
        console.log(`Theme option clicked: ${selectedTheme}`);
        
        // Store the selected theme preference
        localStorage.setItem('theme', selectedTheme);
        
        // Apply theme based on selection
        if (selectedTheme === 'system') {
          const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
          setTheme(systemTheme);
        } else {
          setTheme(selectedTheme);
        }
        
        // Update UI to reflect selection
        updateThemeSelectionUI(selectedTheme);
      });
    });
  } else {
    console.warn("Theme options not found in the DOM");
  }
  
  // Listen for system preference changes
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
    const currentThemePreference = localStorage.getItem('theme');
    if (currentThemePreference === 'system') {
      // Auto-switch if system theme is selected
      setTheme(e.matches ? 'dark' : 'light');
    }
  });
  
  // Ensure images are properly swapped on initial load and with a delay
  setTimeout(() => {
    console.log("Running delayed image swap to ensure all images are loaded");
    swapThemeImages(themeToSet);
  }, 500);
});

// Set the theme by updating the data-theme attribute
function setTheme(theme) {
  console.log(`Setting theme to: ${theme}`);
  document.documentElement.setAttribute('data-theme', theme);
  document.body.classList.remove('theme-light', 'theme-dark');
  document.body.classList.add(`theme-${theme}`);
  updateThemeIcon(theme);
  
  // Handle theme-aware images
  swapThemeImages(theme);
}

// Update the theme selection UI based on the selected theme preference
function updateThemeSelectionUI(preference) {
  console.log(`Updating theme selection UI for preference: ${preference}`);
  // Hide all checkmarks first
  document.querySelectorAll('.theme-check').forEach(check => {
    check.classList.add('d-none');
  });
  
  // Show the appropriate checkmark based on the selected preference
  const selectedCheck = document.querySelector(`.theme-${preference}-check`);
  if (selectedCheck) {
    selectedCheck.classList.remove('d-none');
  }
  
  // Update dropdown button icon
  updateThemeIcon(document.documentElement.getAttribute('data-theme') || 'light');
}

// Update the theme toggle icon based on current theme
function updateThemeIcon(theme) {
  const themeToggleIcon = document.getElementById('theme-toggle-icon');
  if (themeToggleIcon) {
    // Remove all icon classes
    themeToggleIcon.classList.remove('fa-sun', 'fa-moon', 'fa-display');
    
    // Get the current theme preference
    const themePref = localStorage.getItem('theme');
    
    // If using system preference, show display icon
    if (themePref === 'system') {
      themeToggleIcon.classList.add('fa-display');
    } else {
      // Otherwise show icon based on actual theme
      themeToggleIcon.classList.add(theme === 'dark' ? 'fa-moon' : 'fa-sun');
    }
  }
}

// Swap images based on theme
function swapThemeImages(theme) {
  console.log(`Swapping images for ${theme} theme`);
  
  // Find all theme-aware images (with data-theme-src attribute)
  const themeImages = document.querySelectorAll('[data-theme-src-light], [data-theme-src-dark]');
  console.log(`Found ${themeImages.length} theme-aware images`);
  
  themeImages.forEach((img, index) => {
    const lightSrc = img.getAttribute('data-theme-src-light');
    const darkSrc = img.getAttribute('data-theme-src-dark');
    
    console.log(`Image ${index + 1}: light src = ${lightSrc}, dark src = ${darkSrc}`);
    
    if (lightSrc && darkSrc) {
      // Set the appropriate src based on theme
      const previousSrc = img.src;
      if (theme === 'dark' && darkSrc) {
        img.src = darkSrc;
        console.log(`Changed image ${index + 1} from ${previousSrc} to ${darkSrc}`);
      } else if (theme === 'light' && lightSrc) {
        img.src = lightSrc;
        console.log(`Changed image ${index + 1} from ${previousSrc} to ${lightSrc}`);
      }
    }
  });
}