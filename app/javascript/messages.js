document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".list-group-item-action").forEach(function(element) {
    element.addEventListener("click", function(event) {
      event.preventDefault();
      const url = this.getAttribute("href");
      
      fetch(url, {
        headers: {
          "Accept": "text/javascript",
          "X-Requested-With": "XMLHttpRequest",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        credentials: "same-origin"
      })
      .then(response => response.text())
      .then(data => {
        eval(data);
      })
      .catch(error => {
        console.error('Error:', error);
      });
    });
  });

  const messageForm = document.getElementById("new_message_form");
  if (messageForm) {
    messageForm.addEventListener("ajax:success", () => {
      messageForm.reset();
    });
  }
});