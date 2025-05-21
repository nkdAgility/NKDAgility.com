// Theme switcher functionality
document.addEventListener("DOMContentLoaded", function() {
  console.log("Theme switcher loaded");
  // Check for saved theme preference or use system preference
  const savedTheme = localStorage.getItem('theme');
  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  const themeToSet = savedTheme || (systemPrefersDark ? 'dark' : 'light');
  
  // Apply the theme
  setTheme(themeToSet);
  
  // Listen for theme toggle button click
  const themeToggleBtn = document.getElementById('theme-toggle');
  if (themeToggleBtn) {
    console.log("Theme toggle button found, adding event listener");
    themeToggleBtn.addEventListener('click', toggleTheme);
    updateThemeIcon(themeToSet);
  } else {
    console.warn("Theme toggle button not found in the DOM");
  }
  
  // Listen for system preference changes
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
    if (!localStorage.getItem('theme')) {
      // Only auto-switch if user hasn't manually set a preference
      setTheme(e.matches ? 'dark' : 'light');
      updateThemeIcon(e.matches ? 'dark' : 'light');
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
  localStorage.setItem('theme', theme);
  updateThemeIcon(theme);
  
  // Handle theme-aware images
  swapThemeImages(theme);
}

// Toggle between light and dark themes
function toggleTheme() {
  console.log("Toggle theme clicked");
  const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
  const newTheme = currentTheme === 'light' ? 'dark' : 'light';
  console.log(`Switching theme from ${currentTheme} to ${newTheme}`);
  setTheme(newTheme);
}

// Update the theme toggle icon based on current theme
function updateThemeIcon(theme) {
  const themeToggleIcon = document.getElementById('theme-toggle-icon');
  if (themeToggleIcon) {
    // Remove all icon classes
    themeToggleIcon.classList.remove('fa-sun', 'fa-moon');
    
    // Add appropriate icon class based on the theme
    if (theme === 'dark') {
      themeToggleIcon.classList.add('fa-sun'); // Show sun icon in dark mode (to switch to light)
    } else {
      themeToggleIcon.classList.add('fa-moon'); // Show moon icon in light mode (to switch to dark)
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