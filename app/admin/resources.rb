# app/admin/resources.rb
ActiveAdmin.register Resource do
  menu priority: 21, label: "Resources"

  permit_params :title, :description, :publish, :file

  # Scopes
  scope :all
  scope("Published")   { |q| q.where(publish: true) }
  scope("Unpublished") { |q| q.where(publish: false) }

  # Filters
  filter :title
  filter :publish
  filter :created_at

  # Avoid noisy/broken auto-generated ActiveStorage filters
  remove_filter :file_attachment, :file_blob

  # Index
  index do
    selectable_column
    id_column
    column :title
    column :publish do |r|
      status_tag (r.publish ? "Yes" : "No"), class: (r.publish ? "ok" : "warning")
    end
    column "File" do |r|
      if r.file.attached?
        link_to r.file.filename.to_s, url_for(r.file), target: "_blank", rel: "noopener"
      else
        status_tag "No File", class: "warning"
      end
    end
    column :created_at
    actions
  end

  # Show
  show do
    attributes_table do
      row :id
      row :title
      row :publish do |r|
        status_tag (r.publish ? "Published" : "Unpublished"), class: (r.publish ? "ok" : "warning")
      end
      row :description do |r|
        # If CKEditor is used for description, render the HTML safely
        sanitize(
          r.description,
          tags: %w[p br h1 h2 h3 h4 h5 h6 b strong i em u s a ul ol li blockquote code pre span div table thead tbody tr th td],
          attributes: %w[href target rel class style]
        )
      end
      row :file do |r|
        if r.file.attached?
          link_to r.file.filename.to_s, url_for(r.file), target: "_blank", rel: "noopener"
        else
          status_tag "No File", class: "warning"
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
    f.inputs "Resource Details" do
      f.input :title
      # Add class "js-ck" to enable CKEditor if your layout/JS initializes it
      f.input :description, as: :text, input_html: { rows: 12, class: "js-ck" }
      f.input :publish
      f.input :file, as: :file,
              hint: (link_to f.object.file.filename.to_s, url_for(f.object.file), target: "_blank", rel: "noopener" if f.object.file.attached?)
    end
    f.actions
  end
end
