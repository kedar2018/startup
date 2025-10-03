# config/initializers/active_admin_layout.rb
Rails.application.config.to_prepare do
  layout_name = 'active_admin_custom'  # use your file at app/views/layouts/active_admin_custom.html.(arb|erb)

  if defined?(ActiveAdmin::BaseController)
    ActiveAdmin::BaseController.class_eval { layout layout_name }
  end

  if defined?(ActiveAdmin::ResourceController)
    ActiveAdmin::ResourceController.class_eval { layout layout_name }
  end

  if defined?(ActiveAdmin::PageController)
    ActiveAdmin::PageController.class_eval { layout layout_name }
  end
end
