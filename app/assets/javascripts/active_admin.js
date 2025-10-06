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


//= require active_admin/base

(function () {
  alert(11);
  /* ---------- Config ---------- */
  // Font Awesome 5 Free (matches your fas/far/fab classes)
  var FA_CSS = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css";
  // FA icons metadata (list of free icons + styles); pinned to a stable tag:
  var ICONS_JSON = "https://cdn.jsdelivr.net/gh/FortAwesome/Font-Awesome@5.15.4/metadata/icons.json";

  /* ---------- Helpers ---------- */
  function ensureStylesheet(href, attr) {
    if ([].slice.call(document.styleSheets).some(s => s.href && s.href.indexOf(href) >= 0)) return;
    var l = document.createElement("link");
    l.rel = "stylesheet";
    l.href = href;
    if (attr) Object.keys(attr).forEach(k => l.setAttribute(k, attr[k]));
    document.head.appendChild(l);
  }

  function injectPickerStyles() {
    if (document.getElementById("aa-icon-picker-styles")) return;
    var css = `
      .aa-icon-modal-backdrop{position:fixed;inset:0;background:rgba(0,0,0,.35);z-index:10000;display:flex;align-items:center;justify-content:center}
      .aa-icon-modal{background:#fff;border-radius:10px;box-shadow:0 10px 30px rgba(0,0,0,.25);width:min(980px,90vw);max-height:80vh;display:flex;flex-direction:column;overflow:hidden}
      .aa-icon-modal header{padding:.75rem 1rem;border-bottom:1px solid #e5e7eb;display:flex;gap:.75rem;align-items:center}
      .aa-icon-modal header input{flex:1;min-width:0}
      .aa-icon-grid{padding:10px;overflow:auto}
      .aa-icon-grid .aa-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(120px,1fr));gap:8px}
      .aa-icon-card{border:1px solid #e5e7eb;border-radius:8px;padding:8px;display:flex;flex-direction:column;align-items:center;gap:6px;cursor:pointer;background:#fff}
      .aa-icon-card:hover{background:#f8fafc}
      .aa-icon-name{font-size:12px;color:#475569;text-align:center;word-break:break-word}
      .aa-chip{font-size:11px;border:1px solid #e5e7eb;border-radius:999px;padding:2px 8px;background:#f1f5f9;color:#334155}
      .aa-modal-footer{display:flex;justify-content:flex-end;padding:.5rem .75rem;border-top:1px solid #e5e7eb}
      .aa-btn{appearance:none;border:1px solid #cbd5e1;background:#fff;border-radius:6px;padding:.4rem .7rem;cursor:pointer}
      .aa-btn.primary{background:#2563eb;border-color:#2563eb;color:#fff}
      .aa-empty{padding:2rem;color:#64748b;text-align:center}
    `;
    var s = document.createElement("style");
    s.id = "aa-icon-picker-styles";
    s.textContent = css;
    document.head.appendChild(s);
  }

  function fetchIcons() {
    return fetch(ICONS_JSON, { cache: "force-cache" }).then(r => r.json());
  }

  function solidName(k){ return "fas fa-" + k; }
  function regularName(k){ return "far fa-" + k; }
  function brandsName(k){ return "fab fa-" + k; }

  /* ---------- Modal UI ---------- */
  function openIconPicker(opts) {
    var onPick = opts.onPick;
    var currentStyle = opts.currentStyle || "fas";

    var backdrop = document.createElement("div");
    backdrop.className = "aa-icon-modal-backdrop";
    var modal = document.createElement("div");
    modal.className = "aa-icon-modal";
    backdrop.appendChild(modal);

    modal.innerHTML = `
      <header>
        <strong style="white-space:nowrap">Choose an icon</strong>
        <input type="search" class="aa-search form-control" placeholder="Search icons (e.g. user, shield, android)…" />
        <select class="aa-style form-select" style="width:auto;max-width:160px">
          <option value="fas"${currentStyle==="fas"?" selected":""}>Solid</option>
          <option value="far"${currentStyle==="far"?" selected":""}>Regular</option>
          <option value="fab"${currentStyle==="fab"?" selected":""}>Brands</option>
        </select>
        <button class="aa-btn" data-action="close">Close</button>
      </header>
      <div class="aa-icon-grid">
        <div class="aa-grid"></div>
        <div class="aa-empty d-none">No icons match your search.</div>
      </div>
      <div class="aa-modal-footer">
        <small class="text-muted">Font Awesome 5 Free</small>
      </div>
    `;

    document.body.appendChild(backdrop);

    var search = modal.querySelector(".aa-search");
    var styleSel = modal.querySelector(".aa-style");
    var grid = modal.querySelector(".aa-grid");
    var empty = modal.querySelector(".aa-empty");

    var all = []; // [{key, label, styles: ['solid','regular','brands']}]
    var view = []; // filtered

    function render() {
      grid.innerHTML = "";
      var style = styleSel.value; // fas/far/fab
      var shown = 0;
      view.forEach(function (it) {
        // each icon may have multiple styles; render only if available
        var card = document.createElement("button");
        card.type = "button";
        card.className = "aa-icon-card";
        var cls = (style === "fas" ? solidName(it.key)
                 : style === "far" ? regularName(it.key)
                 : brandsName(it.key));
        // hide cards that don't actually exist for that style
        if ((style === "fas" && !it.styles.includes("solid")) ||
            (style === "far" && !it.styles.includes("regular")) ||
            (style === "fab" && !it.styles.includes("brands"))) {
          return; // skip
        }
        card.innerHTML = `
          <i class="${cls}" style="font-size:20px"></i>
          <div class="aa-icon-name">${it.key}</div>
          <span class="aa-chip">${style.toUpperCase()}</span>
        `;
        card.addEventListener("click", function () {
          onPick && onPick({ style: style, name: it.key });
          close();
        });
        grid.appendChild(card);
        shown++;
      });
      empty.classList.toggle("d-none", shown > 0);
    }

    function applyFilter() {
      var q = search.value.trim().toLowerCase();
      if (!q) {
        view = all;
      } else {
        view = all.filter(it => it.key.indexOf(q) >= 0);
      }
      render();
    }

    function close() {
      document.removeEventListener("keydown", onKey);
      backdrop.remove();
    }
    function onKey(e){
      if (e.key === "Escape") close();
    }

    document.addEventListener("keydown", onKey);
    modal.querySelector("[data-action='close']").addEventListener("click", close);
    search.addEventListener("input", applyFilter);
    styleSel.addEventListener("change", render);

    // Load dataset
    fetchIcons().then(function (meta) {
      // meta: { "user": { "styles": ["solid","regular"], ... }, "android": { "styles": ["brands"] } ... }
      all = Object.keys(meta).map(function (k) {
        return { key: k, styles: meta[k].styles || [] };
      }).sort(function (a,b){ return a.key.localeCompare(b.key); });
      view = all;
      render();
    }).catch(function (e) {
      grid.innerHTML = "<div class='aa-empty'>Failed to load icon list.</div>";
      console.error("Icon metadata load failed", e);
    });
  }

  /* ---------- AA wiring ---------- */
  document.addEventListener("active_admin:loaded", function () {
    // Load FA CSS + picker CSS
    ensureStylesheet(FA_CSS, { "data-aa-fa": "1" });
    injectPickerStyles();

    var openBtn = document.getElementById("aa-open-icon-picker");
    if (!openBtn) return;

    var styleInput = document.getElementById("service_icon_style");
    var nameInput  = document.getElementById("service_icon_name");
    var preview    = document.getElementById("aa-icon-preview");

    function updatePreview() {
      var s = (styleInput && styleInput.value) || "fas";
      var n = (nameInput && nameInput.value) || "star";
      if (preview) preview.className = s + " fa-" + n;
    }

    openBtn.addEventListener("click", function (e) {
      e.preventDefault();
      openIconPicker({
        currentStyle: (styleInput && styleInput.value) || "fas",
        onPick: function (icon) {
          if (styleInput) styleInput.value = icon.style;
          if (nameInput)  nameInput.value  = icon.name;
          updatePreview();
        }
      });
    });

    if (styleInput) styleInput.addEventListener("change", updatePreview);
    if (nameInput)  nameInput.addEventListener("input", updatePreview);
    updatePreview();
  });

  // If your AA uses Turbo/Turbolinks, nothing special needed here for the picker.
})();
