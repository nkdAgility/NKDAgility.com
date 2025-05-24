// Font Awesome Performance Monitor
(function() {
  // Check if we should run the monitor (for development/testing only)
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.get('faDebug') !== 'true') return;

  // Records timings of Font Awesome loading
  const faPerformance = {
    start: performance.now(),
    scriptLoaded: 0,
    firstIconReplaced: 0,
    allIconsReplaced: 0,
    iconCount: 0
  };
  
  // Intercept FontAwesome loading events
  const originalFetch = window.fetch;
  window.fetch = function(url, options) {
    const result = originalFetch.apply(this, arguments);
    if (url && typeof url === 'string' && url.includes('fontawesome')) {
      result.then(() => {
        console.log(`[FA Performance] Fetched: ${url}`);
      });
    }
    return result;
  };
  
  // Watch when Font Awesome script loads
  window.addEventListener('load', () => {
    if (window.FontAwesome) {
      faPerformance.scriptLoaded = performance.now();
      console.log(`[FA Performance] Font Awesome script loaded in ${Math.round(faPerformance.scriptLoaded - faPerformance.start)}ms`);
      
      // Count initial icons
      const iconElements = document.querySelectorAll('i.fa, i.fas, i.far, i.fal, i.fad, i.fab');
      faPerformance.iconCount = iconElements.length;
      console.log(`[FA Performance] Found ${faPerformance.iconCount} Font Awesome icons on page`);
      
      // Create observer for when icons are replaced
      const observer = new MutationObserver((mutations) => {
        for (const mutation of mutations) {
          if (mutation.target.tagName === 'svg' && mutation.target.classList.contains('svg-inline--fa')) {
            if (!faPerformance.firstIconReplaced) {
              faPerformance.firstIconReplaced = performance.now();
              console.log(`[FA Performance] First icon replaced in ${Math.round(faPerformance.firstIconReplaced - faPerformance.start)}ms`);
            }
          }
        }
      });
      
      // Start observing
      observer.observe(document.body, { 
        childList: true, 
        subtree: true,
        attributes: true,
        attributeFilter: ['class']
      });
      
      // Check when all icons are replaced
      setTimeout(() => {
        const svgIcons = document.querySelectorAll('svg.svg-inline--fa');
        if (svgIcons.length >= faPerformance.iconCount) {
          faPerformance.allIconsReplaced = performance.now();
          console.log(`[FA Performance] All icons replaced in ${Math.round(faPerformance.allIconsReplaced - faPerformance.start)}ms`);
        }
        
        const totalTime = performance.now() - faPerformance.start;
        console.log(`[FA Performance] Total FA processing time: ${Math.round(totalTime)}ms`);
        
        observer.disconnect();
      }, 1000);
    }
  });
})();