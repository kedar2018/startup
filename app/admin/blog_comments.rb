ActiveAdmin.register ::Comment, as: "BlogComments" do
  permit_params :body, :blog_id, :admin_user_id , :name, :website, :email

  index do
    selectable_column
    id_column
    column :blog
    column :admin_user
    column :body
    column :created_at
    actions
  end

  filter :blog
  filter :admin_user
  filter :created_at

  form do |f|
    f.inputs "Comment Details" do
      f.input :blog
      f.input :admin_user, collection: ::AdminUser.order(:email)
      f.input :body
      f.input :website
      f.input :name
      f.input :website
    end
    f.actions
  end
end
