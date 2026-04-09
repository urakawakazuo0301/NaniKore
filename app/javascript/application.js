import "@hotwired/turbo-rails"
import "controllers"
import "eye"

const alertErrors = () => {
  const errorElement = document.getElementById('errors-for-swal');
  if (errorElement) {
    const message = errorElement.dataset.messages;
    Swal.fire({
      icon: 'error',
      title: '入力内容を確認してください',
      text: message,
      confirmButtonColor: '#3085d6',
      confirmButtonText: 'OK'
    });
    errorElement.remove();
  }
};

document.addEventListener('turbo:load', () => {

  alertErrors();

  if (window.innerWidth <= 600) {
    document.querySelectorAll('.swiper-container').forEach((container) => {
      const id = container.className.match(/swiper-container-(\d+)/)?.[1];
      if (!id) return;

      if (container.classList.contains('swiper-initialized')) return;

      const swiper = new Swiper(`.swiper-container-${id}`, {
        loop: true,
        slidesPerView: 1,
        effect: 'fade',
        pagination: {
          el: `.swiper-pagination-${id}`,
          clickable: true,
        },
        
      });
      container.classList.add('swiper-initialized');
    });
  }
});

document.addEventListener('turbo:render', () => {
  alertErrors();
});

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.btn-mark-as-used').forEach(button => {
    button.addEventListener('click', (event) => {
      event.preventDefault();
      const url = button.getAttribute('href');

      fetch(url, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        },
      }).then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error('Network response was not ok.');
        }
      })
      .then(data => {
        if (data.success) {
          console.log('アイテムが使用済みとしてマークされました');
          
          const itemElement = document.querySelector(`#item-${data.item_id}`);
          if (itemElement) {
            const statusElement = itemElement.querySelector('.item-status');
            if (statusElement) {
              statusElement.textContent = '使用済み';
            }
          }
        }
      })
      .catch(error => {
        console.error('Error:', error);
      });
    });
  });
});