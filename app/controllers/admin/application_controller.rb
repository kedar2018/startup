# app/controllers/admin/application_controller.rb
class Admin::ApplicationController < ActiveAdmin::BaseController
  layout "active_admin" # looks for app/views/layouts/active_admin.html.erb
end
