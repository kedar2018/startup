# app/admin/products.rb
ActiveAdmin.register Product do
  permit_params :title, :description, :content, :image, :attachment

  remove_filter :image_attachment, :image_blob, :attachment_attachment, :attachment_blob
filter :title
  filter :created_at

  form html: { multipart: true } do |f|
    f.semantic_errors
    f.inputs "Product" do
      f.input :title
      f.input :description
      # CKEditor here
      f.input :content, as: :text, input_html: { class: "js-ck", rows: 16 }

      f.input :image, as: :file,
        hint: (image_tag url_for(f.object.image), style: "max-width:140px" if f.object.image.attached?)
      f.input :attachment, as: :file,
        hint: (link_to f.object.attachment.filename, url_for(f.object.attachment) if f.object.attachment.attached?)
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :content do |p|
        # Render HTML from the editor safely
        sanitize(p.content,
          tags: %w[p br h1 h2 h3 h4 h5 h6 b strong i em u s a ul ol li blockquote code pre span div table thead tbody tr th td img],
          attributes: %w[href target rel class style src alt])
      end
      row(:image)      { |p| image_tag url_for(p.image) if p.image.attached? }
      row(:attachment) { |p| link_to p.attachment.filename, url_for(p.attachment) if p.attachment.attached? }
    end
    active_admin_comments
  end
end
