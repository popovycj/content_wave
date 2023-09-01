//= require active_admin/base

document.addEventListener('DOMContentLoaded', () => {
  let profileSelector = document.getElementById('profile_selector');
  let contentTypeSelector = document.getElementById('content_type_selector');

  if (profileSelector && contentTypeSelector) {
    profileSelector.addEventListener('change', () => {
      let selectedProfileId = profileSelector.value;

      contentTypeSelector.innerHTML = "";

      if (selectedProfileId) {
        fetch(`/admin/get_content_types?profile_id=${selectedProfileId}`)
          .then(response => response.json())
          .then(data => {
            data.forEach(contentType => {
              let option = new Option(contentType.title, contentType.id);
              contentTypeSelector.appendChild(option);
            });
          });
      }
    });
  }
});
