const eye = () => {
  // すべての「目のアイコン（eye-iconクラス）」に対して処理を行う
  const eyeIcons = document.querySelectorAll(".eye-icon");

  eyeIcons.forEach(icon => {
    // 重複登録を避けるため、一度クリックイベントをクリアする（Turbo対策）
    icon.onclick = function() {
      // 1. アイコンから見て一番近い親要素「.field」を探す
      const field = icon.closest('.field');
      // 2. その「.field」の中にある「input」を探す
      const input = field.querySelector('input');

      if (input.type === "password") {
        input.type = "text";
        this.textContent = "👁‍🗨"; // 表示中のアイコン
      } else {
        input.type = "password";
        this.textContent = "👁"; // 非表示中のアイコン
      }
    };
  });
};

// Turboの読み込みタイミングに合わせて実行
window.addEventListener(`turbo:load`, eye);
window.addEventListener(`turbo:render`, eye);