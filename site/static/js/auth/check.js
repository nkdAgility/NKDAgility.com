async function checkAuth() {
  try {
    const response = await fetch("/.auth/me");
    const data = await response.json();

    if (data.length > 0) {
      // User is authenticated, show sign-out button
      document.getElementById("signInButton").style.display = "none";
      document.getElementById("signOutButton").style.display = "block";
    } else {
      // User is not authenticated, show sign-in button
      document.getElementById("signInButton").style.display = "block";
      document.getElementById("signOutButton").style.display = "none";
    }
  } catch (error) {
    console.error("Error checking authentication:", error);
  }
}

// Call checkAuth on page load to set initial button visibility
checkAuth();
