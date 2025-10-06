# app/admin/products.rb
ActiveAdmin.register Product do
  # Add icon fields to permitted params
  permit_params :title, :description, :content, :image, :attachment, :icon_style, :icon_name

  # Hide noisy ActiveStorage filters
  remove_filter :image_attachment, :image_blob, :attachment_attachment, :attachment_blob

  # Filters
  filter :title
  filter :icon_style, as: :select, collection: [["Solid (fas)", "fas"], ["Regular (far)", "far"], ["Brands (fab)", "fab"]]
  filter :created_at

  # Index
  index do
    selectable_column
    id_column
    column :title
    column(:description) { |p| truncate p.description.to_s, length: 80 }
    column("Icon") { |p| raw("<i class='#{p.icon_style} fa-#{p.icon_name}'></i>") }
    column :created_at
    actions
  end

  # Form
  form html: { multipart: true } do |f|
    f.semantic_errors
    f.inputs "Product" do
      f.input :title
      f.input :description
      # CKEditor (your layout JS attaches to .js-ck)
      f.input :content, as: :text, input_html: { class: "js-ck", rows: 16 }

      # Icon picker fields (IDs used by the icon-picker JS in your layout)
      f.input :icon_style, as: :select,
                           collection: [["Solid (fas)", "fas"], ["Regular (far)", "far"], ["Brands (fab)", "fab"]],
                           include_blank: false,
                           input_html: { id: "product_icon_style" }

      f.input :icon_name,
              hint: "Type manually or click 'Choose Icon' (e.g. android, shield-alt, users-cog)",
              input_html: { id: "product_icon_name" }

      # Preview + picker trigger
      f.inputs do
        para do
          span "Preview: "
          span raw("<i id='aa-product-icon-preview' class='#{f.object.icon_style.presence || "fas"} fa-#{f.object.icon_name.presence || "star"}' style='font-size:20px;'></i>")
        end
        div do
          a "Choose Icon", href: "#", id: "aa-open-product-icon-picker", class: "button"
        end
      end

      f.input :image, as: :file,
        hint: (image_tag url_for(f.object.image), style: "max-width:140px" if f.object.image.attached?)
      f.input :attachment, as: :file,
        hint: (link_to f.object.attachment.filename, url_for(f.object.attachment) if f.object.attachment.attached?)
    end
    f.actions
  end

  # Show
  show do
    attributes_table do
      row :title
      row :description
      row :content do |p|
        # Render HTML safely
        helpers.sanitize(
          p.content.to_s,
          tags: %w[p br h1 h2 h3 h4 h5 h6 b strong i em u s a ul ol li blockquote code pre span div table thead tbody tr th td img],
          attributes: %w[href target rel class style src alt]
        ).html_safe
      end
      row("Icon") { |p| raw("<i class='#{p.icon_style} fa-#{p.icon_name}' style='font-size:24px;'></i>") }
      row(:image)      { |p| image_tag url_for(p.image) if p.image.attached? }
      row(:attachment) { |p| link_to p.attachment.filename, url_for(p.attachment) if p.attachment.attached? }
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
