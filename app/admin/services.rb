# app/admin/services.rb
ActiveAdmin.register Service do
  menu priority: 30, label: "Services"

  # ✅ Permit all fields you edit here (add/remove to match your model)
  permit_params :title, :description, :content, :icon_style, :icon_name

  # -------- Filters --------
  filter :title
  filter :icon_style, as: :select, collection: [["Solid (fas)", "fas"], ["Regular (far)", "far"], ["Brands (fab)", "fab"]]
  filter :created_at

  # -------- Index --------
  index do
    selectable_column
    id_column
    column :title
    column(:description) { |s| truncate s.description.to_s, length: 80 }
    column("Icon") { |s| raw("<i class='#{s.icon_style} fa-#{s.icon_name}'></i>") }
    column :created_at
    actions
  end

  # -------- Show --------
  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :content do |s|
        # Safely render allowed HTML (if you use CKEditor on content)
        helpers.sanitize(
          s.content.to_s,
          tags: %w[p br strong em a ul ol li h2 h3 h4 blockquote img],
          attributes: %w[href target rel src alt]
        ).html_safe
      end
      row("Icon") { |s| raw("<i class='#{s.icon_style} fa-#{s.icon_name}' style='font-size:24px;'></i>") }
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  # -------- Form --------
  form do |f|
    f.semantic_errors

    f.inputs "Service Details" do
      f.input :title
      f.input :description, as: :text, input_html: { rows: 3 }

      # If you enabled CKEditor for content, it will attach to this textarea via the "js-ckeditor" class.
      #f.input :content, as: :text, input_html: { class: "js-ckeditor", rows: 12 }
      f.input :content, as: :text, input_html: { class: "js-ck", rows: 16 }
      # Icon picker fields (the JS in your layout will target these IDs)
      f.input :icon_style, as: :select,
                           collection: [["Solid (fas)", "fas"], ["Regular (far)", "far"], ["Brands (fab)", "fab"]],
                           include_blank: false,
                           input_html: { id: "service_icon_style" }

      f.input :icon_name,
              hint: "Type manually or click 'Choose Icon' to pick (e.g. android, shield-alt, users-cog)",
              input_html: { id: "service_icon_name" }

      # Preview + icon picker trigger (the JS modal updates the two fields above)
      f.inputs do
        para do
          span "Preview: "
          span raw("<i id='aa-icon-preview' class='#{f.object.icon_style.presence || "fas"} fa-#{f.object.icon_name.presence || "star"}' style='font-size:20px;'></i>")
        end
        div do
          a "Choose Icon", href: "#", id: "aa-open-icon-picker", class: "button"
        end
      end
    end

    f.actions
  end
end
