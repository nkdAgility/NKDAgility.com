const msalConfig = {
  auth: {
    clientId: "f18a31b9-50fb-45ea-ae5a-d904d0b19c67", // From your B2C App Registration
    authority: "https://mynakedagility.ciamlogin.com/mynakedagility.onmicrosoft.com/B2C_1_signup_signin_1", // Replace <USER_FLOW> with your user flow (e.g., B2C_1_signupsignin)
    knownAuthorities: ["mynakedagility.ciamlogin.com", "login.nkdagility.com"],
    redirectUri: "/auth/login", // URL after login
  },
  cache: {
    cacheLocation: "sessionStorage", // or localStorage
    storeAuthStateInCookie: false, // Recommended for browsers with strict cookies
  },
};

const msalInstance = new msal.PublicClientApplication(msalConfig);

function login() {
  const loginRequest = {
    scopes: ["openid", "profile", "email"], // Adjust based on what data you want
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
