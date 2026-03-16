import { Application } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

const application = Application.start();
application.debug = false;
window.Stimulus   = application;

export { application };


// Turboの確認ダイアログを SweetAlert2 に置き換える設定
Turbo.setConfirmMethod((message, element) => {
  return new Promise((resolve, reject) => {
    Swal.fire({
      text: message,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'はい',
      cancelButtonText: 'キャンセル',
      reverseButtons: true
    }).then((result) => {
      // 「はい」なら resolve(true), 「キャンセル」なら resolve(false) を返す
      resolve(result.isConfirmed);
    });
  });
});