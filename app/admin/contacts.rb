# app/admin/contacts.rb
ActiveAdmin.register Contact do
  menu label: "Contacts"

  permit_params :name, :email, :subject, :message

  actions :all

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :subject
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :subject
  filter :created_at

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :subject
      row(:message) { |c| pre c.message }
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :subject
      f.input :message, as: :text
    end
    f.actions
  end
end
