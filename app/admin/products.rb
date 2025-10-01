# app/admin/products.rb
ActiveAdmin.register Product do
  menu priority: 20, label: "Products"

  permit_params :title, :description, :content, :attachment, :image

  # Filters
  filter :title
  filter :created_at

  # Index
  index do
    selectable_column
    id_column
    column :title
    column :description
    column "Image" do |p|
      if p.image.attached?
        image_tag url_for(p.image.variant(resize_to_limit: [80, 80])), style: "border-radius:6px;"
      end
    end
    column :created_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :content do |p|
        pre p.content
      end
      row :image do |p|
        if p.image.attached?
          image_tag url_for(p.image.variant(resize_to_limit: [800, 800]))
        else
          status_tag "No Image", :warning
        end
      end
      row :attachment do |p|
        if p.attachment.attached?
          link_to p.attachment.filename.to_s, url_for(p.attachment), target: "_blank", rel: "noopener"
        else
          status_tag "No Attachment", :warning
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  # Form
  form html: { multipart: true } do |f|
    f.semantic_errors
    f.inputs "Product Details" do
      f.input :title
      f.input :description
      f.input :content, as: :text, input_html: { rows: 8 }
      f.input :image, as: :file, hint: (image_tag url_for(f.object.image) if f.object.image.attached?)
      f.input :attachment, as: :file, hint: (link_to f.object.attachment.filename, url_for(f.object.attachment) if f.object.attachment.attached?)
    end
    f.actions
  end

  # Strong params are handled by permit_params above; no custom controller needed.
end
