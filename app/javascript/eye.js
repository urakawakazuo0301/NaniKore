const eye = () => {
    function setupPasswordToggle(toggleId, passwordId) {
      const toggleElement = document.getElementById(toggleId);
      const passwordField = document.getElementById(passwordId);

      if (toggleElement && passwordField) {
        toggleElement.addEventListener("click", function() {
          const type = passwordField.getAttribute("type") === "password" ? "text" : "password";
          passwordField.setAttribute("type", type);
          this.textContent = type === "password" ? "👁" : "👁‍🗨";
        });
      }
    }

    setupPasswordToggle("togglePasswordRegister", "passRegister");
    setupPasswordToggle("togglePasswordConfirmationRegister", "passConfirmationRegister");
    setupPasswordToggle("togglePasswordLogin", "passLogin");
  };

window.addEventListener(`turbo:load`, eye);
window.addEventListener(`turbo:render`, eye);