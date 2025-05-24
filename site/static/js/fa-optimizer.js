// Font Awesome Optimizer
document.addEventListener('DOMContentLoaded', function() {
  // This will run after Font Awesome has replaced icons
  if (window.FontAwesome) {
    // Force immediate icon processing rather than waiting
    window.FontAwesome.dom.watch({
      observeMutations: false, // Manual control
      autoReplaceSvg: false,   // Already done by initial load
    });
    
    // Manually trigger replacement once to ensure all icons are processed
    window.FontAwesome.dom.i2svg();
  }
  
  // Remove any unnecessary Font Awesome CSS that might have been loaded
  document.querySelectorAll('style[data-fa-detection]').forEach(style => {
    if (style.innerHTML.includes('font-family: "Font Awesome')) {
      style.remove();
    }
  });
});