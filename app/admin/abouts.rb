ActiveAdmin.register About do
  menu priority: 25, label: "About"

  permit_params :title, :description, :content

  # Filters
  filter :title
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :title
    column :description do |a|
      truncate a.description, length: 100
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :description do |a|
        pre style: "white-space:pre-wrap" do
          a.description
        end
      end
      row :content do |a|
        pre style: "white-space:pre-wrap" do
          a.content
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    f.inputs "About Details" do
      f.input :title
      f.input :description, as: :text, input_html: { rows: 4 }
    #  f.input :content,     as: :text, input_html: { rows: 10 }
      f.input :content, as: :text, input_html: { class: "js-ck", rows: 16 }
    end
    f.actions
  end
end
