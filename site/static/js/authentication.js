const msalConfig = {
  auth: {
    clientId: "f18a31b9-50fb-45ea-ae5a-d904d0b19c67", // Application (client) ID from your CIAM tenant
    authority: "https://login.ciamlogin.com/login.nkdagility.com/", // Authority URL for Microsoft Entra External ID (CIAM)
    knownAuthorities: ["login.ciamlogin.com", "login.nkdagility.com"], // Domain of the authority (without paths)
    redirectUri: "/auth/login", // Redirect URI after login
  },
  cache: {
    cacheLocation: "sessionStorage", // Store tokens in sessionStorage
    storeAuthStateInCookie: false, // Set to true for legacy browser support if needed
  },
};

const msalInstance = new msal.PublicClientApplication(msalConfig);

function login() {
  const loginRequest = {
    scopes: ["openid", "profile", "email"], // Scopes needed for authentication
  };

  msalInstance
    .loginPopup(loginRequest)
    .then((response) => {
      console.log(response);
    })
    .catch((error) => {
      console.error(error);
    });
}
