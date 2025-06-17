// Appearance switcher functionality (enhanced theme switcher)
document.addEventListener("DOMContentLoaded", function() {
  console.log("Appearance switcher loaded");
  
  // Initialize all appearance settings
  initializeTheme();
  initializeTextSize();
  initializeTextFont();
  
  // Handle theme option clicks
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
  }
  
  // Handle text size option clicks
  const textSizeOptions = document.querySelectorAll('.text-size-option');
  if (textSizeOptions.length > 0) {
    console.log("Text size options found, adding event listeners");
    textSizeOptions.forEach(option => {
      option.addEventListener('click', (e) => {
        const selectedSize = e.currentTarget.getAttribute('data-text-size');
        console.log(`Text size option clicked: ${selectedSize}`);
        
        // Store and apply the selected text size
        localStorage.setItem('textSize', selectedSize);
        setTextSize(selectedSize);
        updateTextSizeSelectionUI(selectedSize);
      });
    });
  }
  
  // Handle text font option clicks
  const textFontOptions = document.querySelectorAll('.text-font-option');
  if (textFontOptions.length > 0) {
    console.log("Text font options found, adding event listeners");
    textFontOptions.forEach(option => {
      option.addEventListener('click', (e) => {
        const selectedFont = e.currentTarget.getAttribute('data-text-font');
        console.log(`Text font option clicked: ${selectedFont}`);
        
        // Store and apply the selected text font
        localStorage.setItem('textFont', selectedFont);
        setTextFont(selectedFont);
        updateTextFontSelectionUI(selectedFont);
      });
    });
  }
  
  // Listen for system preference changes
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
    const currentThemePreference = localStorage.getItem('theme');
    if (currentThemePreference === 'system') {
      // Auto-switch if system theme is selected
      setTheme(e.matches ? 'dark' : 'light');
    }
  });
});

// Initialize theme settings
function initializeTheme() {
  const savedTheme = localStorage.getItem('theme');
  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  
  let themeToSet;
  let themePreference = savedTheme || 'system';
  
  if (themePreference === 'system') {
    themeToSet = systemPrefersDark ? 'dark' : 'light';
    localStorage.setItem('theme', 'system');
  } else {
    themeToSet = themePreference;
  }
  
  setTheme(themeToSet);
  updateThemeSelectionUI(themePreference);
  
  // Ensure images are properly swapped on initial load
  setTimeout(() => {
    console.log("Running delayed image swap to ensure all images are loaded");
    swapThemeImages(themeToSet);
  }, 500);
}

// Initialize text size settings
function initializeTextSize() {
  const savedTextSize = localStorage.getItem('textSize') || 'medium';
  setTextSize(savedTextSize);
  updateTextSizeSelectionUI(savedTextSize);
}

// Initialize text font settings
function initializeTextFont() {
  const savedTextFont = localStorage.getItem('textFont') || 'default';
  setTextFont(savedTextFont);
  updateTextFontSelectionUI(savedTextFont);
}

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

// Set text size by updating CSS classes
function setTextSize(size) {
  console.log(`Setting text size to: ${size}`);
  document.body.classList.remove('text-size-small', 'text-size-medium', 'text-size-large');
  document.body.classList.add(`text-size-${size}`);
}

// Set text font by updating CSS classes
function setTextFont(font) {
  console.log(`Setting text font to: ${font}`);
  document.body.classList.remove('text-font-default', 'text-font-dyslexic');
  document.body.classList.add(`text-font-${font}`);
}

// Update the theme selection UI
function updateThemeSelectionUI(preference) {
  console.log(`Updating theme selection UI for preference: ${preference}`);
  document.querySelectorAll('.theme-check').forEach(check => {
    check.classList.add('d-none');
  });
  
  const selectedCheck = document.querySelector(`.theme-${preference}-check`);
  if (selectedCheck) {
    selectedCheck.classList.remove('d-none');
  }
  
  updateThemeIcon(document.documentElement.getAttribute('data-theme') || 'light');
}

// Update the text size selection UI
function updateTextSizeSelectionUI(size) {
  console.log(`Updating text size selection UI for size: ${size}`);
  document.querySelectorAll('.text-size-check').forEach(check => {
    check.classList.add('d-none');
  });
  
  const selectedCheck = document.querySelector(`.text-size-${size}-check`);
  if (selectedCheck) {
    selectedCheck.classList.remove('d-none');
  }
}

// Update the text font selection UI
function updateTextFontSelectionUI(font) {
  console.log(`Updating text font selection UI for font: ${font}`);
  document.querySelectorAll('.text-font-check').forEach(check => {
    check.classList.add('d-none');
  });
  
  const selectedCheck = document.querySelector(`.text-font-${font}-check`);
  if (selectedCheck) {
    selectedCheck.classList.remove('d-none');
  }
}

// Update the theme toggle icon based on current theme
function updateThemeIcon(theme) {
  const themeToggleIcon = document.getElementById('theme-toggle-icon');
  if (themeToggleIcon) {
    themeToggleIcon.classList.remove('fa-sun', 'fa-moon', 'fa-display');
    
    const themePref = localStorage.getItem('theme');
    
    if (themePref === 'system') {
      themeToggleIcon.classList.add('fa-display');
    } else {
      themeToggleIcon.classList.add(theme === 'dark' ? 'fa-moon' : 'fa-sun');
    }
  }
}

// Swap images based on theme (existing functionality)
function swapThemeImages(theme) {
  console.log(`Swapping images for ${theme} theme`);
  
  const themeImages = document.querySelectorAll('[data-theme-src-light], [data-theme-src-dark]');
  console.log(`Found ${themeImages.length} theme-aware images`);
  
  themeImages.forEach((img, index) => {
    const lightSrc = img.getAttribute('data-theme-src-light');
    const darkSrc = img.getAttribute('data-theme-src-dark');
    
    console.log(`Image ${index + 1}: light src = ${lightSrc}, dark src = ${darkSrc}`);
    
    if (lightSrc && darkSrc) {
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