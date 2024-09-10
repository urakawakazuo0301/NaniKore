document.addEventListener("DOMContentLoaded", function() {
  // パスワード表示切り替えの機能を一般化する関数
  function setupPasswordToggle(toggleId, passwordId) {
    const toggleElement = document.getElementById(toggleId);
    const passwordField = document.getElementById(passwordId);

    if (toggleElement && passwordField) {
      toggleElement.addEventListener("click", function() {
        const type = passwordField.getAttribute("type") === "password" ? "text" : "password";
        passwordField.setAttribute("type", type);
        this.textContent = type === "password" ? "😎" : "🫣";
      });
    }
  }

  // 新規登録ページのパスワード表示切り替え
  setupPasswordToggle("togglePasswordRegister", "passRegister");
  setupPasswordToggle("togglePasswordConfirmationRegister", "passConfirmationRegister");

  // ログインページのパスワード表示切り替え
  setupPasswordToggle("togglePasswordLogin", "passLogin");
});