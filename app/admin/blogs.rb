ActiveAdmin.register Blog do
  permit_params :title, :body, :admin_user_id, :cover_image, :remove_cover_image,
                comments_attributes: [:id, :body, :admin_user_id, :_destroy]

  index do
    selectable_column
    id_column
    column :title
    column :admin_user
    column :created_at
    column "Image" do |blog|
      if blog.cover_image.attached?
        image_tag url_for(blog.cover_image.variant(resize_to_limit: [80, 80])), style: "border-radius:6px;"
      end
    end
    actions
  end

  filter :title
  filter :admin_user
  filter :created_at

  form html: { multipart: true } do |f|
    f.inputs "Blog Details" do
      f.input :admin_user, collection: ::AdminUser.order(:email) # or :id/:name if you have those
      f.input :title
      f.input :body
    end

    f.inputs "Cover Image" do
      if f.object.cover_image.attached?
        div do
          span "Current:"
          br
          span do
            image_tag url_for(f.object.cover_image.variant(resize_to_limit: [320, 180])),
                      style: "max-width:320px; height:auto; border-radius:8px; border:1px solid #ddd; padding:4px;"
          end
        end
        f.input :remove_cover_image, as: :boolean, label: "Remove current image?"
      end
      f.input :cover_image, as: :file, hint: "JPEG/PNG/WEBP, up to 5MB"
    end

    f.inputs "Comments" do
      f.has_many :comments, allow_destroy: true, new_record: "Add Comment" do |c|
        c.input :admin_user, collection: ::AdminUser.order(:email)
        c.input :body, input_html: { rows: 3 }
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :body
      row :admin_user
      row :created_at
      row :updated_at
      row :cover_image do |blog|
        if blog.cover_image.attached?
          image_tag url_for(blog.cover_image.variant(resize_to_limit: [800, 450])),
                    style: "max-width:100%; height:auto; border-radius:8px; border:1px solid #eee; padding:6px;"
        else
          em "No image uploaded"
        end
      end
    end

    panel "Comments" do
      table_for blog.comments.order(created_at: :desc) do
        column :id
        column :admin_user
        column :body
        column :created_at
      end
    end
  end

  controller do
    def update
      if params[:blog][:remove_cover_image] == "1"
        resource.cover_image.purge_later if resource.cover_image.attached?
      end
      super
    end
  end
end
