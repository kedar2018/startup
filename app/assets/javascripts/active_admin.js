// app/assets/javascripts/active_admin.js
//= require active_admin/base
(function () {
  function ensureCKEditor(cb) {
    if (window.ClassicEditor) { cb(); return; }
    var s = document.createElement('script');
    s.src = 'https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js';
    s.onload = cb; s.async = true; document.head.appendChild(s);
  }
  function initEditors(scope) {
    var root = scope || document;
    var nodes = root.querySelectorAll('textarea.js-ck:not([data-cked])');
    if (!nodes.length) return;
    ensureCKEditor(function () {
      nodes.forEach(function (el) {
        if (el.dataset.cked === '1') return;
        ClassicEditor.create(el).then(() => el.dataset.cked = '1')
          .catch(e => console.error('CKEditor init error:', e));
      });
    });
  }
  document.addEventListener('DOMContentLoaded', () => initEditors(document));
  if (window.jQuery) jQuery(document).on('pjax:complete has_many_add:after', (_e, c) => initEditors((c&&c[0])||document));
})();
