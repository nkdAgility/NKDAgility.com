document.addEventListener("DOMContentLoaded", function () {
  const currencyDropdown = document.querySelector("[data-nkda-currency-dropdown]");
  const currencyButtons = document.querySelectorAll(".currency-option");
  let selectedCurrency = localStorage.getItem("selectedCurrency") || "USD"; // Get from localStorage or default to USD
  let exchangeRates = null;

  // Hide dropdown by default
  if (currencyDropdown) {
    currencyDropdown.parentElement.style.display = "none";
  }

  // Helper: update currency check marks
  function updateCurrencyChecks(currency) {
    console.log(`[CurrencySwitcher] Updating check marks for currency: ${currency}`);

    // Hide all check marks
    const allChecks = document.querySelectorAll(".currency-check");
    console.log(`[CurrencySwitcher] Found ${allChecks.length} check mark elements`);
    allChecks.forEach((check) => {
      check.classList.add("d-none");
    });

    // Show check mark for selected currency
    const selectedCheck = document.querySelector(`.currency-${currency}-check`);
    console.log(`[CurrencySwitcher] Looking for .currency-${currency}-check`);
    if (selectedCheck) {
      selectedCheck.classList.remove("d-none");
      console.log(`[CurrencySwitcher] Check mark shown for ${currency}`);
    } else {
      console.warn(`[CurrencySwitcher] Check mark element not found for currency: ${currency}`);
      // List all available check mark classes
      allChecks.forEach((check) => {
        console.log(`[CurrencySwitcher] Available check mark class: ${check.className}`);
      });
    }
  }

  // Helper: set initial check mark when dropdown is available
  function setInitialCheckMark() {
    console.log(`[CurrencySwitcher] Setting initial check mark for: ${selectedCurrency}`);
    console.log(`[CurrencySwitcher] Currency dropdown exists: ${!!currencyDropdown}`);

    if (currencyDropdown) {
      // Check if dropdown is hidden
      const dropdownContainer = currencyDropdown.parentElement;
      const isHidden = dropdownContainer && dropdownContainer.style.display === "none";
      console.log(`[CurrencySwitcher] Dropdown container hidden: ${isHidden}`);

      updateCurrencyChecks(selectedCurrency);
    } else {
      console.warn("[CurrencySwitcher] Currency dropdown not available for initial check mark");
    }
  }

  // Set initial check mark immediately if dropdown exists
  setInitialCheckMark();

  // Helper: get currency symbol
  function getSymbol(currency) {
    const symbols = {
      USD: "$",
      EUR: "€",
      GBP: "£",
      JPY: "¥",
      AUD: "A$",
      CAD: "C$",
      CHF: "CHF",
      CNY: "¥",
      INR: "₹",
      // Add more as needed
    };
    return symbols[currency] || currency;
  }

  // Helper: clean and parse amount string
  function parseAmount(amountString) {
    if (!amountString) return NaN;
    // Remove commas, spaces, and other common formatting characters
    // Keep only digits, decimal points, and minus signs
    const cleaned = amountString
      .toString()
      .replace(/[,\s]/g, "")
      .replace(/[^\d.-]/g, "");
    return parseFloat(cleaned);
  }

  // Helper: round amount up to nearest value
  function roundToNearest(amount, roundTo) {
    if (!roundTo || roundTo <= 0) return amount;
    return Math.ceil(amount / roundTo) * roundTo;
  }

  // Helper: format amount
  function formatAmount(amount, currency, roundTo = null) {
    // Apply rounding if specified
    if (roundTo) {
      amount = roundToNearest(amount, roundTo);
    }

    return amount.toLocaleString(undefined, {
      style: "decimal",
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
  }

  // Helper: find exchange rate between two currencies
  function getExchangeRate(fromCurrency, toCurrency) {
    if (fromCurrency === toCurrency) return 1;

    // Look for direct conversion
    const directRate = exchangeRates.find((rate) => rate.BaseCurrency === fromCurrency && rate.TargetCurrency === toCurrency);
    if (directRate) return directRate.ExchangeRate;

    // Look for inverse conversion
    const inverseRate = exchangeRates.find((rate) => rate.BaseCurrency === toCurrency && rate.TargetCurrency === fromCurrency);
    if (inverseRate) return 1 / inverseRate.ExchangeRate;

    // Try to find conversion through GBP (base currency)
    if (fromCurrency !== "GBP" && toCurrency !== "GBP") {
      const fromGBP = getExchangeRate("GBP", fromCurrency);
      const toGBP = getExchangeRate("GBP", toCurrency);
      if (fromGBP && toGBP) {
        return toGBP / fromGBP;
      }
    }

    console.warn(`[CurrencySwitcher] No exchange rate found for ${fromCurrency} to ${toCurrency}`);
    return null;
  }

  // Update all currency spans
  function updateCurrencies(selectedCurrency) {
    if (!exchangeRates) {
      console.warn("[CurrencySwitcher] Exchange rates not loaded.");
      return;
    }
    const currencySpans = document.querySelectorAll('[data-nkda-toggle="currency"]');
    if (currencySpans.length === 0) {
      console.info("[CurrencySwitcher] No currency spans found on page.");
    }
    currencySpans.forEach((span) => {
      const base = span.getAttribute("data-nkda-base");
      const amountString = span.getAttribute("data-nkda-amount");
      const roundToString = span.getAttribute("data-nkda-round");
      const amount = parseAmount(amountString);
      const roundTo = roundToString ? parseFloat(roundToString) : null;

      if (!base || isNaN(amount)) {
        console.error("[CurrencySwitcher] Invalid span:", span, "base:", base, "amount:", amountString);
        return;
      }

      let converted = amount;
      if (base !== selectedCurrency) {
        const rate = getExchangeRate(base, selectedCurrency);
        if (rate) {
          converted = amount * rate;
        } else {
          console.error(`[CurrencySwitcher] Could not convert from ${base} to ${selectedCurrency}`);
          // fallback: show original amount
          converted = amount;
        }
      }

      // Apply rounding if specified
      if (roundTo && roundTo > 0) {
        converted = roundToNearest(converted, roundTo);
        console.log(`[CurrencySwitcher] Rounded ${amount * (base !== selectedCurrency ? getExchangeRate(base, selectedCurrency) : 1)} to ${converted} (nearest ${roundTo})`);
      }

      // Set the title attribute to show original value with currency
      const originalValueTitle = `Original: ${getSymbol(base)}${formatAmount(amount, base)}`;
      span.setAttribute("title", originalValueTitle);

      span.textContent = getSymbol(selectedCurrency) + formatAmount(converted, selectedCurrency);
    });
  }

  // Fetch exchange rates
  fetch("/data/exchangeRates.json")
    .then((res) => {
      if (!res.ok) {
        console.error(`[CurrencySwitcher] Failed to fetch exchange rates: ${res.status}`);
        return Promise.reject(res.status);
      }
      return res.json();
    })
    .then((data) => {
      exchangeRates = data;
      console.info("[CurrencySwitcher] Exchange rates loaded:", exchangeRates);
      // Show dropdown only if currency spans exist
      const currencySpans = document.querySelectorAll('[data-nkda-toggle="currency"]');
      if (currencySpans.length > 0 && currencyDropdown) {
        currencyDropdown.parentElement.style.display = "";
        updateCurrencyChecks(selectedCurrency);
        updateCurrencies(selectedCurrency);
      } else {
        if (currencyDropdown) currencyDropdown.parentElement.style.display = "none";
        console.info("[CurrencySwitcher] No currency spans found, dropdown hidden.");
      }
    })
    .catch((err) => {
      console.error("[CurrencySwitcher] Error loading exchange rates:", err);
    });

  // Listen for currency button clicks
  currencyButtons.forEach((button) => {
    button.addEventListener("click", function () {
      selectedCurrency = this.getAttribute("data-currency");
      localStorage.setItem("selectedCurrency", selectedCurrency);
      console.info(`[CurrencySwitcher] Currency changed to: ${selectedCurrency}`);
      updateCurrencyChecks(selectedCurrency);
      updateCurrencies(selectedCurrency);
    });
  });
});
