// Theme switcher functionality
document.addEventListener("DOMContentLoaded", function() {
  // Check for saved theme preference or use system preference
  const savedTheme = localStorage.getItem('theme');
  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  const themeToSet = savedTheme || (systemPrefersDark ? 'dark' : 'light');
  
  // Apply the theme
  setTheme(themeToSet);
  
  // Listen for theme toggle button click
  const themeToggleBtn = document.getElementById('theme-toggle');
  if (themeToggleBtn) {
    themeToggleBtn.addEventListener('click', toggleTheme);
    updateThemeIcon(themeToSet);
  }
  
  // Listen for system preference changes
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
    if (!localStorage.getItem('theme')) {
      // Only auto-switch if user hasn't manually set a preference
      setTheme(e.matches ? 'dark' : 'light');
      updateThemeIcon(e.matches ? 'dark' : 'light');
    }
  });
});

// Set the theme by updating the data-theme attribute
function setTheme(theme) {
  document.documentElement.setAttribute('data-theme', theme);
  localStorage.setItem('theme', theme);
  updateThemeIcon(theme);
}

// Toggle between light and dark themes
function toggleTheme() {
  const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
  const newTheme = currentTheme === 'light' ? 'dark' : 'light';
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